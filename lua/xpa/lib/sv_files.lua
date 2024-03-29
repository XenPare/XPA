--[[
	XPA.AddResourceDir(path/to/the/folder)
]]

function XPA.AddResourceDir(dir)
	local files, dirs = file.Find(dir .. "/*", "GAME")
	for _, fdir in pairs(dirs) do
		if fdir ~= ".svn" then
			XPA.AddResourceDir(dir .. "/" .. fdir)
		end
	end
	for _, f in pairs(files) do
		resource.AddFile(dir .. "/" .. f)
	end
end
