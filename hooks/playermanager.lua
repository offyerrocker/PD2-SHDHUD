--identical to basegame
local function make_double_hud_string(a, b)
	return string.format("%01d|%01d", a, b)
end

--edited to include slot parameters
local function add_hud_item(amount, icon, slot)
	if #amount > 1 then
		managers.hud:add_item_from_string({
			amount_str = make_double_hud_string(amount[1], amount[2]), -- this string isn't actually used
			amount = amount,
			icon = icon,
			slot = slot
		})
	else
		managers.hud:add_item({
			amount = amount[1],
			icon = icon,
			slot = slot
		})
	end
end

--identical to basegame
local function get_as_digested(amount)
	local list = {}

	for i = 1, #amount, 1 do
		table.insert(list, Application:digest_value(amount[i], false))
	end

	return list
end

-- identical to basegame
local function set_hud_item_amount(index, amount)
	if #amount > 1 then
		managers.hud:set_item_amount_from_string(index, make_double_hud_string(amount[1], amount[2]), amount)
	else
		managers.hud:set_item_amount(index, amount[1])
	end
end

Hooks:PostHook(PlayerManager,"_internal_load","playermanager_internalload",function(self)
	managers.hud:shdhud_chk_add_deployables()
end)

Hooks:OverrideFunction(PlayerManager,"switch_equipment",function(self)
	self:select_next_item()
	local equipment = self:selected_equipment() 
	if not (equipment or _G.IS_VR) then
		local td = tweak_data.equipments[managers.blackmarket:equipped_deployable(self._equipment.selected_index)]
		if not td then 
			-- no second deployable; probably no JOAT
			return
		end
		local icon = td.icon
		add_hud_item({0},icon)
		--don't update to peers either
	elseif equipment and not _G.IS_VR then 
		local digested = get_as_digested(equipment.amount)
		add_hud_item(digested,equipment.icon)
		self:update_deployable_selection_to_peers()	
	end
end)

Hooks:OverrideFunction(PlayerManager,"select_next_item",function(self)
	local prev_index = self._equipment.selected_index
	if not prev_index then
		return
	end
	
	local selections = self._equipment and self._equipment.selections
	local num_selections = selections and #selections
	local new_index = 1 + (prev_index % num_selections)
	local new_eq = selections[new_index]
	local count = #new_eq.amount
	local valid
	
	for i = 1, count do
		if Application:digest_value(new_eq.amount[i], false) > 0 then
			valid = true
		end
	end
	
	if valid then
		self._equipment.selected_index = new_index
		managers.hud:shdhud_switch_deployable(prev_index,new_index)
	end
end)

Hooks:OverrideFunction(PlayerManager,"select_previous_item",function(self)
	local prev_index = self._equipment.selected_index
	if not prev_index then
		return
	end
	
	local selections = self._equipment and self._equipment.selections
	local num_selections = selections and #selections
	local new_index = 1 + ((num_selections - prev_index) % num_selections)
	local new_eq = selections[new_index]
	local count = #new_eq.amount
	local valid
	
	for i = 1, count do
		if Application:digest_value(new_eq.amount[i], false) > 0 then
			valid = true
		end
	end
	
	if valid then
		self._equipment.selected_index = new_index
		managers.hud:shdhud_switch_deployable(prev_index,new_index)
	end
end)

Hooks:PostHook(PlayerManager,"remove_equipment","playermanager_removeequipment",function(self,equipment_id,slot)
	managers.hud:shdhud_upd_deployable_equipments()
end)
