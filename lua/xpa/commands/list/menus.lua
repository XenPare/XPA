return "Menus", "*", {
	--[[
		xpa info
	]]

	["info"] = {
		name = "Info",
		icon = "icon16/help.png",
		visible = true,
		self = true,
		func = function(pl)
			local msg = "XenPare Administration Experience " .. XPA.Version .. ", build from " .. XPA.Build .. " by " .. XPA.Author

			if IsValid(pl) then
				XPA.SendMsg(pl, msg)
			else
				MsgC(Color(0, 160, 255), msg)
			end
		end
	},

	--[[
		xpa finder
	]]

	["finder"] = {
		name = "Finder",
		icon = "icon16/magnifier.png",
		visible = true,
		self = true,
		func = function(pl)
			if not IsValid(pl) then
				return
			end

			local cmp = util.Compress(util.TableToJSON(XPA.Playtime))
			local len = #cmp
			net.Start("XPA Finder")
				net.WriteUInt(len, 16)
				net.WriteData(cmp, len)
				net.WriteTable(XPA.Restrictions)
				net.WriteTable(XPA.Bans)
			net.Send(pl)
		end
	},

	--[[
		xpa menu
	]]

	["menu"] = {
		name = "Menu",
		icon = "icon16/help.png",
		self = true,
		func = function(pl)
			if not IsValid(pl) then
				return
			end

			local init = table.Copy(XPA.Commands)
			for cmd, data in pairs(init) do
				if data.immunity and data.immunity > pl:GetImmunity() then
					init[cmd] = nil
					continue
				end
				if not data.visible then
					init[cmd] = nil
					continue
				end
				if data.autocompletion then
					data.autocompletion = nil
				end
				if data.check then
					data.check = nil
				end
				if data.init then
					data.init = nil
				end
				data.func = nil
			end
			net.Start("XPA Menu")
				net.WriteTable(XPA.GetCommandCategories())
				net.WriteTable(init)
			net.Send(pl)
		end
	}
}, false