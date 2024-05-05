local SHDHUDPlayer = SHDHUDCore:require("classes/SHDHUDPlayer")
local SHDHUDTeammate = SHDHUDCore:require("classes/SHDHUDTeammate")

Hooks:PostHook(HUDManager,"_setup_player_info_hud_pd2","kshdhud_hudmanagerpd2_setupplayerhud",function(self,hud)
	local new_ws = managers.gui_data:create_fullscreen_workspace("shdhud")
	local master_panel = new_ws:panel()
	
	SHDHUDCore._testws = new_ws
	SHDHUDCore._panel = master_panel
	self._shdhud_teammates = {}
	local MAX_PLAYERS = 4
	for i=1,MAX_PLAYERS,1 do 
		local hud
		if i == HUDManager.PLAYER_PANEL then
			hud = SHDHUDPlayer:new(master_panel,i)
			self._shdhud_player = hud
		else
			hud = SHDHUDTeammate:new(master_panel,i)
		end
		self._shdhud_teammates[i] = hud
	end
	fooshd = self._shdhud_player
	
end)

function HUDManager:hide_player_gear(panel_id)
	
	self._shdhud_teammates[panel_id]:hide()
	
--[[
	if self._teammate_panels[panel_id] and self._teammate_panels[panel_id]:panel() and self._teammate_panels[panel_id]:panel():child("player") then
		local player_panel = self._teammate_panels[panel_id]:panel():child("player")
		local teammate_panel = self._teammate_panels[panel_id]

		player_panel:child("weapons_panel"):set_visible(false)
		teammate_panel._deployable_equipment_panel:set_visible(false)
		teammate_panel._cable_ties_panel:set_visible(false)
		teammate_panel._grenades_panel:set_visible(false)
	end
	--]]
	--self._shdhud_player:hide()
end

function HUDManager:show_player_gear(panel_id)
	self._shdhud_teammates[panel_id]:show()
--[[
	if self._teammate_panels[panel_id] and self._teammate_panels[panel_id]:panel() and self._teammate_panels[panel_id]:panel():child("player") then
		local player_panel = self._teammate_panels[panel_id]:panel():child("player")
		local teammate_panel = self._teammate_panels[panel_id]

		player_panel:child("weapons_panel"):set_visible(true)
		teammate_panel._deployable_equipment_panel:set_visible(true)
		teammate_panel._cable_ties_panel:set_visible(true)
		teammate_panel._grenades_panel:set_visible(true)
	end
	--]]
	--self._shdhud_player:show()
end

------------------------------------------------
--*************** PLAYER PANEL ***************--
------------------------------------------------


	-- Vitals
function HUDManager:set_player_armor(data)
	if data.current == 0 and not data.no_hint then
		managers.hint:show_hint("damage_pad")
	end

	self._shdhud_player:set_armor(data)
	--self:set_teammate_armor(HUDManager.PLAYER_PANEL, data)
end

function HUDManager:set_player_health(data)
	self._shdhud_player:set_health(data)
	--self:set_teammate_health(HUDManager.PLAYER_PANEL, data)
end


	-- Weapons/Ammo
function HUDManager:set_ammo_amount(selection_index, max_clip, current_clip, current_left, max_left)
	self._shdhud_player:set_ammo_amount(selection_index,max_clip,current_clip,current_left,max_left)
	--Print("index",selection_index,"max_clip",max_clip,"current_clip",current_clip,"current_left",current_left,"max_left",max_left)
	--self._shdhud_player:set_magazine_amount(selection_index,current_clip,max_clip)
	--self._shdhud_player:set_reserve_amount(selection_index,current_left,max_left)
	managers.player:update_synced_ammo_info_to_peers(selection_index, max_clip, current_clip, current_left, max_left)
end



function HUDManager:_set_weapon_selected(id)
--	self._hud.selected_weapon = id
--	local icon = self._hud.weapons[self._hud.selected_weapon].unit:base():weapon_tweak_data().hud_icon

--	self:_set_teammate_weapon_selected(HUDManager.PLAYER_PANEL, id, icon)
	self._shdhud_player:set_weapon_selected(id)
end

function HUDManager:set_alt_ammo(state)
	for _, o in pairs(self._shdhud_teammates) do
		o:set_alt_ammo(state)
	end
end

do return end


function HUDManager:set_weapon_selected_by_inventory_index(inventory_index)
	--Print("Inventory index",inventory_index)
end



function HUDManager:_set_weapon(data)
--[[
	local unit = data.unit
	local weapon_base = alive(unit) and unit:base()
	if weapon_base then
		local weapon_id = weapon_base:get_name_id()
		local slot = data.inventory_index or 1
		local is_underbarrel = false
		self:_set_player_weapon_icon(HUDManager.PLAYER_PANEL,weapon_id,slot,is_underbarrel)

		local weapon_perks = {}
		local ATTACHMENT_PERKS = RookHUD.WEAPON_ATTACHMENT_PERKS
		local PERK_WHITELIST = ATTACHMENT_PERKS.ICONS
		local PERK_NAME_CONVERSION = ATTACHMENT_PERKS.SHORTNAMES
		local PERK_ORDER = ATTACHMENT_PERKS.ORDER
		local STATES = ATTACHMENT_PERKS.STATES
		local blueprint = weapon_base._blueprint
		local wftd = tweak_data.weapon.factory.parts
		
		local teammate_panel = self._teammate_panels[HUDManager.PLAYER_PANEL]
		local current_firemode = weapon_base:fire_mode()
		
		if weapon_base:can_toggle_firemode() and not weapon_base._locked_fire_mode then
			if weapon_base._toggable_fire_modes then
				teammate_panel:_create_weapon_perk_icon(slot,is_underbarrel,PERK_NAME_CONVERSION[current_firemode],STATES.ON)
				for _,fire_mode in pairs(weapon_base._toggable_fire_modes) do 
					local state
					if fire_mode ~= current_firemode then
						state = STATES.ON
					else
						state = STATES.OFF
					end
					teammate_panel:_create_weapon_perk_icon(slot,is_underbarrel,PERK_NAME_CONVERSION[fire_mode],state)
				end
			else
				if current_firemode == "single" then
					teammate_panel:_create_weapon_perk_icon(slot,is_underbarrel,PERK_NAME_CONVERSION[current_firemode],STATES.ON) --singlefire should be ordered first
					teammate_panel:_create_weapon_perk_icon(slot,is_underbarrel,"autofire",STATES.OFF)
				elseif current_firemode == "auto" then
					teammate_panel:_create_weapon_perk_icon(slot,is_underbarrel,"singlefire",STATES.OFF)
					teammate_panel:_create_weapon_perk_icon(slot,is_underbarrel,PERK_NAME_CONVERSION[current_firemode],STATES.ON)
				end
			end
		else
			teammate_panel:_create_weapon_perk_icon(slot,is_underbarrel,PERK_NAME_CONVERSION[current_firemode],STATES.LOCKED)
		end
		
		
		local function register_perk(perk_type)
			perk_type = PERK_NAME_CONVERSION[perk_type] or perk_type
			if PERK_WHITELIST[perk_type] and not table.contains(weapon_perks,perk_type) then
				table.insert(weapon_perks,perk_type)
			end
		end
		local function register_part(part_data)
			local perk_type = part_data.type
			if perk_type == "ammo" or perk_type == "gadget" or perk_type == "extra" then
				perk_type = part_data.sub_type
			end
			if perk_type then
				register_perk(perk_type)
			end
		end
		
		for k,part_id in pairs(blueprint) do 
			local part_data = wftd[part_id]
			if part_data then
				local adds = part_data.adds
				if adds then
					for _,add_part_id in pairs(adds) do 
						local add_part_data = wftd[add_part_id]
						if add_part_data then
							if add_part_data.perks then
								register_part(add_part_data)
								
								for _,add_perk in ipairs(add_part_data.perks) do 
									register_perk(add_perk)
								end
							end
						end
					end
				end
				
				register_part(part_data)
				
				local perks = part_data.perks
				if perks then
					for _,perk_type in ipairs(perks) do 
						register_perk(perk_type)
					end
				end
			end
		end
		
		table.sort(weapon_perks,function(a,b)
			local i_a = table.index_of(PERK_ORDER,a)
			local i_b = table.index_of(PERK_ORDER,b)
			if i_a > i_b then
				return true
			elseif i_a <= i_b then
				return false
			end
			return false
		end)
		
		
		for _,perk_name in ipairs(weapon_perks) do 
			local perk_data = PERK_WHITELIST[perk_name] 
			teammate_panel:_create_weapon_perk_icon(slot,is_underbarrel,perk_name,perk_data.default_state or STATES.OFF)
		end
	end
	--]]
end

--custom
function HUDManager:_set_player_weapon_perk(slot,is_underbarrel,perk_type,state)
	--self._teammate_panels[HUDManager.PLAYER_PANEL]:set_weapon_perk_icon(slot,is_underbarrel,perk_type,state)
end

--custom
function HUDManager:_set_player_weapon_icon(i,weapon_id,slot,is_underbarrel)
	--self._teammate_panels[i]:_set_weapon_item_icon_by_weapon_id(slot,is_underbarrel,weapon_id)
end

--custom
function HUDManager:check_main_ammo()
--[[
	local player = managers.player:local_player()
	if alive(player) then
		local inventory = player:inventory()
		if inventory then
			for id,weapon in pairs(inventory:available_selections()) do 
				--get the ammo info of the weapon, disregarding the underbarrel
				local base = weapon.unit:base()
				self:set_own_ammo_amount(id,base:get_ammo_max_per_clip(),base:get_ammo_remaining_in_clip(),base:get_ammo_total(),base:get_ammo_max())
			end
		end
	end
	--]]
end

--custom
function HUDManager:check_underbarrel_ammo()
--[[
	local player = managers.player:local_player()
	if alive(player) then
		local inventory = player:inventory()
		if inventory then
			for id,weapon in pairs(inventory:available_selections()) do 
				for _,underbarrel_base in pairs(weapon.unit:base():get_all_override_weapon_gadgets()) do 
					self:set_own_ammo_amount(id+2,RaycastWeaponBase.ammo_info(underbarrel_base))

--					local ammo = underbarrel_base._ammo
--					self:set_own_ammo_amount(id + 2,ammo._ammo_max_per_clip or ammo._ammo_max_per_clip2,ammo._ammo_remaining_in_clip or ammo._ammo_remaining_in_clip2,ammo._ammo_total,ammo._ammo_max or ammo._ammo_max2)
					--underbarrel_base:ammo_info() isn't always loaded when this is called since the unit is initialized and passed before the extensions are initialized
					break
				end
			end
		end
	end
	--]]
end


function HUDManager:set_ammo_amount(selection_index, max_clip, current_clip, current_left, max_reserves)
--[[
	if selection_index > 4 then
		return
	end
	managers.player:update_synced_ammo_info_to_peers(selection_index, max_clip, current_clip, current_left, max_reserves)
--	Print(selection_index,current_clip,debug.traceback())
	local player = managers.player:local_player()
	if alive(player) then
		if selection_index <= 2 then
			local inv_ext = player:inventory()
			local unit = inv_ext:unit_by_selection(selection_index)
			local base = unit:base()
			local underbarrel = base:gadget_overrides_weapon_functions()
			if underbarrel then
				--don't update the ammo count if the selection index is incorrect (ie if the underbarrel is active)
				
--				selection_index = selection_index + 2
				return
			end
		else
		
		end
	end
	self:set_own_ammo_amount(selection_index, max_clip, current_clip, current_left, max_reserves)
	--]]
end

function HUDManager:set_own_ammo_amount(selection_index, max_clip, current_clip, current_left, max_reserves) --custom
	--self._teammate_panels[HUDManager.PLAYER_PANEL]:set_ammo_amount(selection_index, max_clip, current_clip, current_left, max_reserves)
end

function HUDManager:switch_player_deployable(selection_index) --custom
	--self._teammate_panels[HUDManager.PLAYER_PANEL]:animate_switch_deployables(selection_index)
end

function HUDManager:_set_teammate_weapon_selected(i, id, icon)
--	self._teammate_panels[i]:set_weapon_selected(id, icon)
end

function HUDManager:recreate_weapon_firemode(i)
--	if self._teammate_panels[i] then
--		self._teammate_panels[i]:recreate_weapon_firemode()
--	end
end

function HUDManager:add_waiting(peer_id, override_index)
--[[
	if not Network:is_server() then
		return
	end

	local peer = managers.network:session():peer(peer_id)

	if override_index then
		self._waiting_index[peer_id] = override_index
	end

	local index = self:get_waiting_index(peer_id)
	local panel = self._teammate_panels[index]

	if panel and peer then
		panel:set_waiting(true, peer)

		local _ = not self._waiting_legend:is_set() and self._waiting_legend:show_on(panel, peer)
	end
	--]]
end

function HUDManager:remove_waiting(peer_id)
--[[
	if not Network:is_server() then
		return
	end

	local index = self:get_waiting_index(peer_id)
	self._waiting_index[peer_id] = nil
	local _ = self._teammate_panels[index] and self._teammate_panels[index]:set_waiting(false)

	if self._waiting_legend:peer() and peer_id == self._waiting_legend:peer():id() then
		self._waiting_legend:turn_off()

		for id, index in pairs(self._waiting_index) do
			local panel = self._teammate_panels[index]
			local peer = managers.network:session():peer(id)

			if panel then
				self._waiting_legend:show_on(panel, peer)

				break
			end
		end
	end
	--]]
end

function HUDManager:set_teammate_weapon_firemode(i, id, firemode)
--	self._teammate_panels[i]:set_weapon_firemode(id, firemode)
end

function HUDManager:set_teammate_ammo_amount(id, selection_index, max_clip, current_clip, current_left, max)
--[[
	selection_index = (tonumber(selection_index) - 1) % 2 + 1
	local type = selection_index == 1 and "secondary" or "primary"

	self._teammate_panels[id]:set_ammo_amount_by_type(type, max_clip, current_clip, current_left, max)
	--]]
end

function HUDManager:damage_taken()
--	self._teammate_panels[HUDManager.PLAYER_PANEL]:_damage_taken()
end


----------------------------------------------
--************* TEAMMATE PANEL *************--
----------------------------------------------

	-- ID
function HUDManager:set_teammate_name(i, teammate_name)
--	self._teammate_panels[i]:set_name(teammate_name)
end

function HUDManager:set_teammate_callsign(i, id)
--	self._teammate_panels[i]:set_callsign(id)
end

function HUDManager:set_teammate_state(i, state)
--[[
	if state == "player" then
		self:set_ai_stopped(i, false)
	end

	self._teammate_panels[i]:set_state(state)
	--]]
end


	-- Vitals
function HUDManager:set_teammate_armor(i, data)
--	self._teammate_panels[i]:set_armor(data)
end

function HUDManager:set_teammate_health(i, data)
--	self._teammate_panels[i]:set_health(data)
end

function HUDManager:set_teammate_delayed_damage(i, delayed_damage)
--	self._teammate_panels[i]:set_delayed_damage(delayed_damage)
end

function HUDManager:set_stored_health(stored_health_ratio)
--	self._teammate_panels[HUDManager.PLAYER_PANEL]:set_stored_health(stored_health_ratio)
end



	-- Grenades/Throwables/Abilities
function HUDManager:set_player_custom_radial(data)
--	self:set_teammate_custom_radial(HUDManager.PLAYER_PANEL, data)
end

function HUDManager:set_teammate_custom_radial(i, data)
--	self._teammate_panels[i]:set_custom_radial(data)
end

function HUDManager:set_teammate_ability_radial(i, data)
--	self._teammate_panels[i]:set_ability_radial(data)
end

function HUDManager:activate_teammate_ability_radial(i, time_left, time_total)
--	self._teammate_panels[i]:activate_ability_radial(time_left, time_total)
end

function HUDManager:set_cable_tie(i, data)
--	self._teammate_panels[i]:set_cable_tie(data)
end

function HUDManager:set_cable_ties_amount(i, amount)
--	self._teammate_panels[i]:set_cable_ties_amount(amount)
end

