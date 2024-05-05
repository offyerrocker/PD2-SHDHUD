local SHDHUDPanel = SHDHUDCore:require("classes/SHDHUDPanel")
local SHDHUDTeammate = class(SHDHUDPanel)

function SHDHUDTeammate:init(master_panel,index)
	self._id = index
	self._alt_ammo = managers.user:get_setting("alt_hud_ammo")
	
	self.config = {}
	self.data = {}
	
	
	local hud_panel = master_panel:panel({
		name = "hud_panel",
		layer = 1,
		w = 256,
		h = 100,
		x = 640,
		y = 500
	})
	self._panel = hud_panel
	
	self:create_hud()
end

function SHDHUDTeammate:panel()
	return self._panel
end

function SHDHUDTeammate:show()
	self._panel:show()
end

function SHDHUDTeammate:hide()
	self._panel:hide()
end

function SHDHUDTeammate:set_alt_ammo(enabled)
	self._alt_ammo = enabled
end

function SHDHUDTeammate:create_hud()
	
end

function SHDHUDTeammate:set_health()
	
end

function SHDHUDTeammate:set_armor()
	
end

function SHDHUDTeammate:set_delayed_damage()

end

function SHDHUDTeammate:set_stored_health()

end

function SHDHUDTeammate:set_revives()
	
end

function SHDHUDTeammate:set_status()
	
end

function SHDHUDTeammate:set_cable_ties()
	
end





-- returns a fresh table with a copy of all of this panel's data,
-- without saving any references that would impede garbage collection
function SHDHUDTeammate:save()
	local out_data = {}
	
	--self.data
	
	return out_data
end

-- setup the visual hud elements with the provided data
function SHDHUDTeammate:load(data)
	
end




return SHDHUDTeammate
