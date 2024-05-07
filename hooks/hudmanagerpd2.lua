local SHDHUDPlayer = SHDHUDCore:require("classes/SHDHUDPlayer")
local SHDHUDCriminalBase = SHDHUDCore:require("classes/SHDHUDCriminalBase")

Hooks:PostHook(HUDManager,"_setup_player_info_hud_pd2","kshdhud_hudmanagerpd2_setupplayerhud",function(self,hud)
	local new_ws = managers.gui_data:create_fullscreen_workspace("shdhud")
	local master_panel = new_ws:panel()
	
	SHDHUDCore._testws = new_ws
	SHDHUDCore._panel = master_panel
	self._shdhud_teammates = {}
	local MAX_PLAYERS = _G.BigLobbyGlobals and _G.BigLobbyGlobals.num_players_settings or 4
	for i=1,MAX_PLAYERS,1 do 
		local hud
		if i == HUDManager.PLAYER_PANEL then
			hud = SHDHUDPlayer:new(master_panel,i)
			self._shdhud_player = hud
		else
			hud = SHDHUDCriminalBase:new(master_panel,i)
		end
		self._shdhud_teammates[i] = hud
	end
	fooshd = self._shdhud_player
	
end)

function HUDManager:shdhud_on_mission_loud()
	self._shdhud_player:unfold_armor_bar()
end

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
--[[
	notes:
	weapon_base:ammo_info() shows the currently loaded ammo- it will show underbarrel ammo if underbarrel is activated
	by extension set_ammo_amount will receive whatever ammo is currently equipped (both are updated at the same time)
	therefore, SHDHUD's internal ammo counts for weapons not currently equipped must be updated and maintained through other means
--]]

-- set visual ammo counter display for equipped weapons
-- called when ammo count is changed, or underbarrel is toggled
function HUDManager:set_ammo_amount(selection_index, max_clip, current_clip, current_left, max_left)
	-- specifically when switching to/from a weapon whose underbarrel is active,
	-- the game will erroneously state that the selected index is the BASE WEAPON,
	-- and not the UNDERBARREL WEAPON.
	-- in most other cases, the game seems to correctly pass the selected index (1,2,3,4).
	-- unfortunately, that one failure means we need to re-check the game's work every time!
	
	local player = managers.player:local_player()
	if alive(player) then
		local inventory = player:inventory()
		if inventory then
			local selection_index_base = 1 + (selection_index - 1) % 2 -- selection index of the given base weapon
			local is_equipped = inventory:is_equipped(selection_index_base)
			
			if selection_index_base == selection_index then -- game could be lying about not using underbarrel
				local unit = inventory:unit_by_selection(selection_index_base)
				local weapon_base = alive(unit) and unit:base()
				if weapon_base then
					local underbarrel_base = weapon_base:gadget_overrides_weapon_functions()
					if underbarrel_base then
						local td = underbarrel_base._tweak_data
						local use_data = td and td.use_data
						local underbarrel_index = use_data and use_data.selection_index
						-- if the parent weapon for the underbarrel is currently equipped,
						-- tell shdhud that the underbarrel is the actually equipped weapon
						if underbarrel_index then
							
							selection_index = underbarrel_index
							
							if not is_equipped then
							--[[
								max_clip = underbarrel_base:get_ammo_max_per_clip()
								current_clip = underbarrel_base:get_ammo_remaining_in_clip()
								current_left = underbarrel_base:get_ammo_total()
								max_left = underbarrel_base:get_ammo_max()
							--]]
							end
						end
					end
				end
			end
			
			if is_equipped then
				self._shdhud_player:set_weapon_selected(selection_index)
			end
		end
	end
	
	self._shdhud_player:set_ammo_amount(selection_index,max_clip,current_clip,current_left,max_left)
	
	managers.player:update_synced_ammo_info_to_peers(selection_index, max_clip, current_clip, current_left, max_left)
end

-- init cache ammo values
function HUDManager:_set_weapon(data)
	local unit = data.unit
	local weapon_base = alive(unit) and unit:base()
	if weapon_base and weapon_base.ammo_info then
		self._shdhud_player:add_weapon(data.inventory_index,weapon_base:ammo_info())
		
		-- also cache underbarrel ammo values
		for _,underbarrel in pairs(weapon_base:get_all_override_weapon_gadgets()) do
			local td = underbarrel._tweak_data
			local use_data = td and td.use_data
			local selection_index = use_data and use_data.selection_index
			local ammo_info = underbarrel._ammo
			if selection_index and ammo_info then
				self._shdhud_player:add_weapon(
					selection_index,
					ammo_info._ammo_max_per_clip or 0,
					ammo_info._ammo_remaining_in_clip or 0,
					ammo_info._ammo_total or 0,
					ammo_info._ammo_max or 0
				)
				break -- take the first valid underbarrel; there will probably only be one per weapon anyhow
			end
		end
		
		-- update ammo counts for stowed weapons (assume that underbarrels do not start out as activated)
		if data.is_equip then
			self._shdhud_player:upd_backpack_ammo(data.inventory_index)
		else
			local player = managers.player:local_player()
			if alive(player) then
				local inventory = player:inventory()
				local selection_index = inventory and inventory._equipped_selection
				if selection_index then
					self._shdhud_player:upd_backpack_ammo(selection_index)
				end
			end
		end
	end
	
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

-- prompt chk backpack reserve values
function HUDManager:_set_teammate_weapon_selected(i,id,icon)
	if i == HUDManager.PLAYER_PANEL then
		local player = managers.player:local_player()
		if alive(player) then
			local inventory = player:inventory()
			local unit = inventory and inventory:unit_by_selection(id)
			if unit then
				local weapon_base = unit:base()
				if not weapon_base then
					local underbarrel = weapon_base:gadget_overrides_weapon_functions()
					if underbarrel then
						local td = underbarrel._tweak_data
						local use_data = td and td.use_data
						local selection_index = use_data and use_data.selection_index
						if selection_index then
							self._shdhud_player:set_weapon_selected(selection_index)
							return
						end
					end
				end
			end
		end
		
		self._shdhud_player:set_weapon_selected(id)
	end
	
end

function HUDManager:set_alt_ammo(state)
	for _, o in pairs(self._shdhud_teammates) do
		o:set_alt_ammo(state)
	end
end


	-- Deployable Equipment

function HUDManager:shdhud_switch_deployable(prev_index,new_index)
	self._shdhud_teammates[HUDManager.PLAYER_PANEL]:switch_deployable(prev_index,new_index)
end

function HUDManager:shdhud_upd_deployable_equipments()
	for index,eq in pairs(managers.player._equipment.selections) do 
		local amount_digested = eq.amount
		local id = eq.equipment
		local amounts = {}
		for i=1,#amount_digested,1 do 
			amounts[i] = Application:digest_value(amount_digested[i], false)
		end
		
		self:shdhud_set_deployable_equipment(HUDManager.PLAYER_PANEL,{
			id = id,
			slot = index,
			amount = amounts
		})
	end
end

function HUDManager:shdhud_chk_add_deployables()
	local pmeq = managers.player._equipment
	local equipped_index = pmeq.selected_index
	for index,eq in pairs(pmeq.selections) do 
		local amount_digested = eq.amount
		local id = eq.equipment
		local td = tweak_data.equipments[id]
		local icon = td.icon
		
		local amounts = {}
		for i=1,#amount_digested,1 do 
			amounts[i] = Application:digest_value(amount_digested[i], false)
		end
		if equipped_index == index then
			self:shdhud_switch_deployable(nil,equipped_index)
		else
			self:shdhud_switch_deployable(index,nil)
		end
		self:shdhud_add_deployable_equipment(HUDManager.PLAYER_PANEL,{
			icon = icon,
			id = id,
			slot = index,
			amount = amounts
		})
	end
end

function HUDManager:shdhud_add_deployable_equipment(i,data)
	self._shdhud_teammates[i]:add_deployable(data)
end

function HUDManager:shdhud_set_deployable_equipment(i,data)
	self._shdhud_teammates[i]:set_deployable_amount(data)
end

function HUDManager:set_deployable_equipment(i, data)
	if i == HUDManager.PLAYER_PANEL then
		self:shdhud_upd_deployable_equipments()
	end
end

function HUDManager:set_item_amount(index, amount)
	self:shdhud_set_deployable_equipment(HUDManager.PLAYER_PANEL,{
		slot = index,
		amount = {
			amount,
			nil
		}
	})
end

function HUDManager:set_item_amount_from_string(index, amount_str, amount)
	self:shdhud_set_deployable_equipment(HUDManager.PLAYER_PANEL,{
		slot = index,
		amount = amount
	})
end

function HUDManager:set_deployable_equipment_from_string(i, data)
	if i == HUDManager.PLAYER_PANEL then
		self:shdhud_upd_deployable_equipments()
	end
end

--[[
function HUDManager:set_teammate_deployable_equipment_amount(i, index, data)
	self._teammate_panels[i]:set_deployable_equipment_amount(index, data)
end

function HUDManager:set_teammate_deployable_equipment_amount_from_string(i, index, data)
	self._teammate_panels[i]:set_deployable_equipment_amount_from_string(index, data)
end

function HUDManager:add_item(data)
	self:set_deployable_equipment(HUDManager.PLAYER_PANEL, data)
end

function HUDManager:add_item_from_string(data)
	self:set_deployable_equipment_from_string(HUDManager.PLAYER_PANEL, data)
end
--]]

	-- Cable Ties

function HUDManager:set_cable_tie(i, data)
	self._shdhud_teammates[i]:add_cable_ties(data)
end

function HUDManager:set_cable_ties_amount(i, amount)
	self._shdhud_teammates[i]:set_cable_ties(amount)
end


	-- Throwables
	
Hooks:OverrideFunction(HUDManager,"set_teammate_grenades",function(self,i,data)
	self._shdhud_teammates[i]:set_grenades(data)
end)

Hooks:OverrideFunction(HUDManager,"set_teammate_grenades_amount",function(self,i,data)
	self._shdhud_teammates[i]:set_grenades_amount(data)
end)

Hooks:OverrideFunction(HUDManager,"set_teammate_grenade_cooldown",function(self,i,data)
	self._shdhud_teammates[i]:set_grenade_cooldown(data)
end)

Hooks:OverrideFunction(HUDManager,"set_ability_icon",function(self,i,icon)
	self._shdhud_teammates[i]:set_ability_icon(icon)
end)

Hooks:OverrideFunction(HUDManager,"set_teammate_ability_radial",function(self,i,data)
	self._shdhud_teammates[i]:set_ability_radial(data)
end)

Hooks:OverrideFunction(HUDManager,"activate_teammate_ability_radial",function(self,i,time_left,time_total)
	self._shdhud_teammates[i]:activate_ability_radial(time_left,time_total)
end)

Hooks:OverrideFunction(HUDManager,"set_teammate_custom_radial",function(self,i,data)
	self._shdhud_teammates[i]:set_custom_radial(data)
end)



do return end


function HUDManager:set_weapon_selected_by_inventory_index(inventory_index)
	--Print("Inventory index",inventory_index)
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

function HUDManager:set_own_ammo_amount(selection_index, max_clip, current_clip, current_left, max_reserves) --custom
	--self._teammate_panels[HUDManager.PLAYER_PANEL]:set_ammo_amount(selection_index, max_clip, current_clip, current_left, max_reserves)
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
