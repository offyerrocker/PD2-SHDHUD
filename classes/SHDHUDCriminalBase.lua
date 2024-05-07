local SHDHUDPanel = SHDHUDCore:require("classes/SHDHUDPanel")
local SHDHUDCriminalBase = class(SHDHUDPanel)

function SHDHUDCriminalBase:init(master_panel,index,...)
	SHDHUDCriminalBase.super.init(self,master_panel,...)
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
	
	local groupaimgr = managers.groupai and managers.groupai:state()
	local is_police_called = groupaimgr and groupaimgr:is_police_called()
	
	self.data = {
		low_armor_anim = nil, -- will hold the coroutine for alpha flashing health hud anim
		low_health_anim = nil, -- will hold the coroutine for alpha flashing health hud anim
		is_health_bar_unfolded = false,
		revives_current = 0,
		health_current = 0,
		health_total = 0,
		is_armor_bar_unfolded = is_police_called or false,
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
				reserve_max = 0
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

function SHDHUDCriminalBase:add_weapon(index,magazine_max,magazine_current,reserve_current,reserve_max)
	local wpn_info
	if self.data.weapons[index] then
		wpn_info = self.data.weapons[index]
	else
		wpn_info = {}
		self.data.weapons[index] = wpn_info
	end
	wpn_info.magazine_max = magazine_max or wpn_info.magazine_max or 0
	wpn_info.magazine_current = magazine_current or wpn_info.magazine_current or 0
	wpn_info.reserve_current = reserve_current or wpn_info.reserve_current or 0
	wpn_info.reserve_max = reserve_max or wpn_info.reserve_max or 0
	return wpn_info
end

function SHDHUDCriminalBase:set_ammo_amount(selection_index,max_clip,current_clip,current_left,max_left)
	
end

function SHDHUDCriminalBase:set_weapon_selected(id,hud_icon)
	
end

function SHDHUDCriminalBase:add_deployable(data)
	
end

function SHDHUDCriminalBase:switch_deployable(prev_index,new_index)
	
end

function SHDHUDCriminalBase:set_deployable_amount(data)
	
end

function SHDHUDCriminalBase:add_cable_ties(data)

end

function SHDHUDCriminalBase:set_cable_ties(i, amount)

end

function SHDHUDCriminalBase:set_grenades(data)

end
function SHDHUDCriminalBase:set_grenade_cooldown(data)

end
function SHDHUDCriminalBase:set_ability_icon(icon)

end
function SHDHUDCriminalBase:set_grenades_amount(data)

end
function SHDHUDCriminalBase:activate_ability_radial(data)

end
function SHDHUDCriminalBase:set_ability_radial(data)

end

function SHDHUDCriminalBase:set_custom_radial(data)

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
