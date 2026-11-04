--- @since 26.9.1
--
-- Prompt for a shell command and run it over the current selection, with the
-- selected paths appended as arguments, or the hovered file if none are selected.

local selected_or_hovered = ya.sync(function()
	local tab = cx.active
	local count = 0
	for _ in pairs(tab.selected) do
		count = count + 1
	end
	if count == 0 and tab.current.hovered then
		count = 1
	end
	return count
end)

local function trim(s)
	return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

return {
	entry = function()
		if selected_or_hovered() == 0 then
			return ya.notify {
				title = "Run command",
				content = "No file selected",
				level = "warn",
				timeout = 5,
			}
		end

		local value, event = ya.input {
			title = "Run command on selection:",
			pos = { "top-center", y = 3, w = 80 },
		}
		if event ~= 1 then
			return
		end

		value = trim(value or "")
		if value == "" then
			return
		end

		ya.emit("shell", {
			run = "sh -c " .. ya.quote(value .. ' "$@"', true) .. " yazi %s",
			block = true,
		})
	end,
}
