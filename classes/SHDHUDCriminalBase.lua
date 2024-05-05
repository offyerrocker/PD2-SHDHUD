local SHDHUDPanel = SHDHUDCore:require("classes/SHDHUDPanel")
local SHDHUDCriminalBase = class(SHDHUDPanel)

function SHDHUDCriminalBase:init(master_panel,index,...)
	SHDHUDCriminalBase.super.init(self,master_panel,index,...)
	self._id = index
	self._alt_ammo = managers.user:get_setting("alt_hud_ammo")
	
	self.config = {
		use_armor_segments = true,
		armor_segment_amount = 20, -- how much armor is in one segment
		armor_segment_group_size = 5, -- how many armor segments are in one group (20 * 5 = 100 ap in one segment group)
		armor_segment_margin_small = 0.25,
		armor_segment_margin_large = 0.5,
		armor_segments_total = 5,
		armor_low_threshold = 0.25, -- below 25% will be considered "low health"
		use_health_segments = false,
		health_segment_amount = 20,
		health_segment_group_size = 5,
		health_segment_margin_small = 0.25,
		health_segment_margin_large = 0.5,
		health_segments_total = 5,
		health_low_threshold = 0 -- effectively disabled low health flashing warnings
	}
	
	self.data = {
		low_armor_anim = nil, -- will hold the coroutine for alpha flashing health hud anim
		low_health_anim = nil, -- will hold the coroutine for alpha flashing health hud anim
		revives_current = 0,
		health_current = 0,
		health_total = 0,
		armor_current = 0,
		armor_total = 0,
		armor_segment_remainder_w = 4,
		armor_segment_w = 9,
		health_segment_w = 9,
		
		equipped_weapon_index = 0,
		weapons = {
			{
				magazine_current = 0,
				magazine_max = 0,
				reserve_current = 0,
				reserve_max = 0,
				is_underbarrel = 0
			}
		}
	}
	
end

function SHDHUDCriminalBase:set_alt_ammo(enabled)
	self._alt_ammo = enabled
end

function SHDHUDCriminalBase:set_health(current,total)
	
end

function SHDHUDCriminalBase:set_armor(current,total)
	
end

function SHDHUDCriminalBase:set_delayed_damage(amount)

end

function SHDHUDCriminalBase:set_stored_health(amount)

end

function SHDHUDCriminalBase:set_revives(amount)
	
end

function SHDHUDCriminalBase:set_status(status)
	
end

function SHDHUDCriminalBase:set_cable_ties(current)
	
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
