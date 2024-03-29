XPA.Commands = XPA.Commands or {}
hook.Add("Initialize", "XPA Command Register", function()
	for _, name in pairs(file.Find("xpa/commands/list/*", "LUA")) do
		local title, gm, commands, opened = include("xpa/commands/list/" .. name)
		if gm ~= "*" then
			if string.find(gm, "/") then
				local gamemodes = string.Explode("/", gm)
				if not table.HasValue(gamemodes, engine.ActiveGamemode()) then
					continue
				end
			else
				if engine.ActiveGamemode() ~= gm then
					continue
				end
			end
		end
		for key, data in pairs(commands) do
			local _gm = data.gamemode
			if _gm then
				if string.find(_gm, "/") then
					local gamemodes = string.Explode("/", _gm)
					if not table.HasValue(gamemodes, engine.ActiveGamemode()) then
						commands[key] = nil
						continue
					end
				else
					if engine.ActiveGamemode() ~= _gm then
						commands[key] = nil
						continue
					end
				end
			end
			if data.check then
				if not data.check() then
					commands[key] = nil
					continue
				end
			end
			if data.aliases then
				local _data = table.Copy(data)
				_data.aliases = nil
				_data.visible = false
				for _, alias in ipairs(data.aliases) do
					commands[alias] = _data
				end
			end
			if data.init then
				data.init()
			end
			data.category = title
			data.opened = opened
		end
		table.Merge(XPA.Commands, commands)
	end
end)

local commands = XPA.Commands
function XPA.GetCommandCategories()
	local tbl = {}
	for _, data in pairs(commands) do
		local cat = data.category
		if not table.HasValue(tbl, cat) then
			table.insert(tbl, cat)
		end
	end
	return tbl
end

function XPA.AddCommand(name, data)
	if data.init then
		data.init()
	end
	XPA.Commands[name] = data
end