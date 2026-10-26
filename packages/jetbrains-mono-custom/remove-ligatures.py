#!/usr/bin/env python3
"""Remove selected character-sequence ligatures from JetBrains Mono fonts."""

import argparse
import json
from pathlib import Path

from fontTools.ttLib import TTFont


def lookup_references(subtable):
    """Yield lookup indices referenced by contextual substitution subtables."""
    for set_name, rule_name in (
        ("SubRuleSet", "SubRule"),
        ("ChainSubRuleSet", "ChainSubRule"),
        ("SubClassSet", "SubClassRule"),
        ("ChainSubClassSet", "ChainSubClassRule"),
    ):
        for rule_set in getattr(subtable, set_name, None) or []:
            if rule_set is None:
                continue
            for rule in getattr(rule_set, rule_name, None) or []:
                for record in rule.SubstLookupRecord:
                    yield record.LookupListIndex

    for record in getattr(subtable, "SubstLookupRecord", []) or []:
        yield record.LookupListIndex


def lookup_subtables(lookup, lookup_types):
    """Yield direct and extension subtables with an allowed lookup type."""
    for subtable in lookup.SubTable:
        if lookup.LookupType == 7:
            if subtable.ExtensionLookupType in lookup_types:
                yield subtable.ExtSubTable, subtable.ExtensionLookupType
        elif lookup.LookupType in lookup_types:
            yield subtable, lookup.LookupType


def referenced_lookups(lookup):
    references = set()
    for subtable, lookup_type in lookup_subtables(lookup, (5, 6)):
        references.update(lookup_references(subtable))
    return references


def is_contextual(lookup):
    return any(True for _ in lookup_subtables(lookup, (5, 6)))


def requested_glyph_sequences(font, sequences):
    cmap = font.getBestCmap() or {}
    glyph_sequences = []
    for sequence in sequences:
        try:
            glyphs = tuple(cmap[ord(character)] for character in sequence)
        except KeyError as error:
            missing = chr(error.args[0])
            raise ValueError(
                f"Font has no cmap entry for {missing!r} in ligature {sequence!r}"
            ) from error
        glyph_sequences.append((sequence, glyphs))
    return glyph_sequences


def remove_from_font(font, sequences):
    if "GSUB" not in font:
        return 0

    gsub = font["GSUB"].table
    lookups = gsub.LookupList.Lookup
    glyph_order = set(font.getGlyphOrder())
    requested = requested_glyph_sequences(font, sequences)

    # JetBrains Mono's contextual rules use names such as
    # asterisk_asterisk_asterisk.liga as their final substitution glyph.
    target_glyphs = set()
    for _sequence, glyphs in requested:
        named_ligature = "_".join(glyphs) + ".liga"
        if named_ligature in glyph_order:
            target_glyphs.add(named_ligature)

    changed = 0

    # Remove direct GSUB ligature substitutions (LookupType 4).
    for lookup in lookups:
        for subtable, _lookup_type in lookup_subtables(lookup, (4,)):
            for first_glyph, ligatures in list(subtable.ligatures.items()):
                kept = []
                for ligature in ligatures:
                    components = (first_glyph, *ligature.Component)
                    if any(components == glyphs for _sequence, glyphs in requested):
                        changed += 1
                        target_glyphs.add(ligature.LigGlyph)
                    else:
                        kept.append(ligature)
                if kept:
                    subtable.ligatures[first_glyph] = kept
                else:
                    del subtable.ligatures[first_glyph]

    # Locate single substitutions that emit JetBrains Mono's named ligature
    # glyphs. The contextual lookup that invokes them is removed below as a
    # whole, preserving the original input characters.
    target_lookups = set()
    for index, lookup in enumerate(lookups):
        for subtable, lookup_type in lookup_subtables(lookup, (1,)):
            matching = {
                input_glyph: output_glyph
                for input_glyph, output_glyph in subtable.mapping.items()
                if output_glyph in target_glyphs
            }
            if matching:
                target_lookups.add(index)
                for input_glyph in matching:
                    del subtable.mapping[input_glyph]
                    changed += 1

    def depends_on_target(index, visiting=frozenset()):
        if index in target_lookups:
            return True
        if index in visiting:
            return False
        next_visiting = visiting | {index}
        return any(
            depends_on_target(reference, next_visiting)
            for reference in referenced_lookups(lookups[index])
        )

    # Remove contextual roots that invoke the targeted substitution. Leaving
    # those roots active can transform the input into an unrelated glyph.
    for feature_record in gsub.FeatureList.FeatureRecord:
        feature = feature_record.Feature
        kept = []
        for index in feature.LookupListIndex:
            if is_contextual(lookups[index]) and depends_on_target(index):
                changed += 1
            else:
                kept.append(index)
        feature.LookupListIndex = kept

    # Keep the character-variant menu from offering removed ligatures.
    for lookup in lookups:
        for subtable, _lookup_type in lookup_subtables(lookup, (3,)):
            for input_glyph, alternates in list(subtable.alternates.items()):
                remaining = [glyph for glyph in alternates if glyph not in target_glyphs]
                if len(remaining) != len(alternates):
                    changed += len(alternates) - len(remaining)
                    if remaining:
                        subtable.alternates[input_glyph] = remaining
                    else:
                        del subtable.alternates[input_glyph]

    return changed


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--sequences", required=True, help="JSON array of input sequences")
    parser.add_argument("font_directory", type=Path)
    args = parser.parse_args()

    sequences = json.loads(args.sequences)
    if not isinstance(sequences, list) or any(
        not isinstance(sequence, str) or not sequence for sequence in sequences
    ):
        raise SystemExit("--sequences must be a JSON array of non-empty strings")
    if not sequences:
        return

    files = sorted(
        path
        for path in args.font_directory.rglob("*")
        if path.suffix.lower() in {".ttf", ".otf", ".woff2"}
    )
    if not files:
        raise SystemExit(f"No supported font files found under {args.font_directory}")

    modified_fonts = 0
    for path in files:
        font = TTFont(path)
        try:
            changed = remove_from_font(font, sequences)
            if changed:
                font.save(path)
                modified_fonts += 1
        finally:
            font.close()

    if modified_fonts == 0:
        requested = ", ".join(repr(sequence) for sequence in sequences)
        raise SystemExit(f"Could not find the requested ligatures ({requested}) in {args.font_directory}")


if __name__ == "__main__":
    main()
