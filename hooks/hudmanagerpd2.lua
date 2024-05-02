local SHDHUDPlayer = SHDHUDCore:require("classes/SHDHUDPlayer")

Hooks:PostHook(HUDManager,"_setup_player_info_hud_pd2","kshdhud_hudmanagerpd2_setupplayerhud",function(self,hud)
	local new_ws = managers.gui_data:create_fullscreen_workspace("shdhud")
	local master_panel = new_ws:panel()
	
	SHDHUDCore._testws = new_ws
	SHDHUDCore._panel = master_panel
	
	self._shdhud_player = SHDHUDPlayer:new(master_panel)
	fooshd = self._shdhud_player
end)

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

function HUDManager:set_ammo_amount(selection_index, max_clip, current_clip, current_left, max_left)
	self._shdhud_player:set_magazine_amount(selection_index,current_clip,max_clip)
	self._shdhud_player:set_reserve_amount(selection_index,current_left,max_left)
--	self._shdhud_player:set_magazine_amount(selection_index,ma
	--[[
	if selection_index > 4 then
		print("set_ammo_amount", selection_index, max_clip, current_clip, current_left, max)
		Application:stack_dump()
		debug_pause("WRONG SELECTION INDEX!")
	end

	managers.player:update_synced_ammo_info_to_peers(selection_index, max_clip, current_clip, current_left, max)
	self:set_teammate_ammo_amount(HUDManager.PLAYER_PANEL, selection_index, max_clip, current_clip, current_left, max)

	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)

	if hud.panel:child("ammo_test") then
		local panel = hud.panel:child("ammo_test")
		local ammo_rect = panel:child("ammo_test_rect")

		ammo_rect:set_w(panel:w() * current_clip / max_clip)
		ammo_rect:set_center_x(panel:w() / 2)
		panel:stop()
		panel:animate(callback(self, self, "_animate_ammo_test"))
	end
	--]]
end