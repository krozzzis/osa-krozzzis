--- @since 26.9.1
local selection = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, url in pairs(tab.selected) do
		paths[#paths + 1] = tostring(url)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

return {
	entry = function(_, job)
		local paths = selection()
		if #paths == 0 then
			return ya.notify { title = "Archive", content = "No file selected", level = "warn", timeout = 5 }
		end

		local command, description
		if job.args[1] == "compress" then
			local formats = { ".zip", ".tar.gz", ".tar.zst", ".7z" }
			local choice = ya.which { cands = {
				{ on = "z", desc = "ZIP" },
				{ on = "g", desc = "TAR.GZ" },
				{ on = "s", desc = "TAR.ZST" },
				{ on = "7", desc = "7Z" },
			} }
			if not choice then return end
			local name = paths[1]:match("([^/]+)/*$") .. formats[choice]
			description = "Create " .. name .. " from " .. #paths .. " item(s)?"
			command = "ouch compress"
			for _, path in ipairs(paths) do command = command .. " " .. ya.quote(path, true) end
			command = command .. " " .. ya.quote(name, true)
		else
			description = "Extract " .. #paths .. " archive(s) here?"
			command = "ouch decompress --here"
			for _, path in ipairs(paths) do command = command .. " " .. ya.quote(path, true) end
		end
		if ya.confirm { pos = { "center", w = 60, h = 10 }, title = "Archive", body = description } then
			ya.emit("shell", { run = command, block = true })
		end
	end,
}
