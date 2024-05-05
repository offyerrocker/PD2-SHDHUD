local SHDHUDPanel = SHDHUDCore:require("classes/SHDHUDPanel")
local SHDHUDCriminalBase = class(SHDHUDPanel)

function SHDHUDCriminalBase:init(master_panel,index)
	self._id = index
	self._alt_ammo = managers.user:get_setting("alt_hud_ammo")
	
	self.config = {}
	self.data = {}
	
	--[[
	local hud_panel = master_panel:panel({
		name = "hud_panel",
		layer = 1,
		w = 256,
		h = 100,
		x = 640,
		y = 500
	})
	self._panel = hud_panel
	--]]
	
	self:create_hud()
end

function SHDHUDCriminalBase:panel()
	return self._panel
end

function SHDHUDCriminalBase:show()
	self._panel:show()
end

function SHDHUDCriminalBase:hide()
	self._panel:hide()
end

function SHDHUDCriminalBase:set_alt_ammo(enabled)
	self._alt_ammo = enabled
end

function SHDHUDCriminalBase:create_hud()
	
end

function SHDHUDCriminalBase:set_health()
	
end

function SHDHUDCriminalBase:set_armor()
	
end

function SHDHUDCriminalBase:set_delayed_damage()

end

function SHDHUDCriminalBase:set_stored_health()

end

function SHDHUDCriminalBase:set_revives()
	
end

function SHDHUDCriminalBase:set_status()
	
end

function SHDHUDCriminalBase:set_cable_ties()
	
end





-- returns a fresh table with a copy of all of this panel's data,
-- without saving any references that would impede garbage collection
function SHDHUDCriminalBase:save()
	local out_data = {}
	
	--self.data
	
	return out_data
end

-- setup the visual hud elements with the provided data
function SHDHUDCriminalBase:load(data)
	
end




return SHDHUDCriminalBase
