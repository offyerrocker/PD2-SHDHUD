local SHDHUDCriminalBase = SHDHUDCore:require("classes/SHDHUDCriminalBase")
local SHDAnimLibrary = SHDHUDCore:require("classes/SHDHUDAnimations")
local SHDHUDPlayer = class(SHDHUDCriminalBase)

local DEBUG_VISIBLE = false


function SHDHUDPlayer.create_backpack_label(parent,name)
	
	local text_color = SHDHUDCore:get_color("player_hud_backpack_text")
	local highlight_color = SHDHUDCore:get_color("player_hud_highlight")
	
	if alive(parent:child(name)) then
		parent:remove(parent:child(name))
	end
	
	local w = parent:w()
	local h = 15 -- 24 --parent:h() / 3
	local panel = parent:panel({
		name = name,
		w = w,
		h = h,
		valign = "grow",
		halign = "grow",
		visible = false
	})
	
	local label = panel:text({
		name = "label",
		color = text_color,
		text = "00",
		font = "fonts/borda_semibold",
		font_size = 16, -- 20
		kern = -20,
		monospace = true,
		align = "center",
		vertical = "center",
		layer = 2
	})
	
	local fg = panel:rect({
		name = "fg",
		color = highlight_color,
		alpha = 0.5,
		layer = 0,
		valign = "grow",
		halign = "grow",
		visible = false
	})
	
	return panel
end

function SHDHUDPlayer.create_deployable_box(parent,name)
	if alive(parent:child(name)) then
		parent:remove(parent:child(name))
	end
	
	local icon_color = SHDHUDCore:get_color("player_hud_deployable_icon")
	local text_color = SHDHUDCore:get_color("player_hud_deployable_full")
	local highlight_color = SHDHUDCore:get_color("player_hud_highlight")
	
	local w = parent:w()/2
	local h = parent:h()
	local panel = parent:panel({
		name = name,
		w = w,
		h = h,
		valign = "grow",
		halign = "grow"
	})
	
	local bg = panel:rect({
		name = "bg",
		color = highlight_color,
		alpha = 0.5,
		layer = 0,
		visible = false
	})
	
	local icon, texture_rect = tweak_data.hud_icons:get_icon_data("equipment_doctor_bag")
	local icon = panel:bitmap({
		name = "icon",
		texture = icon,
		texture_rect = texture_rect,
		color = icon_color,
		x = 0,
		w = 16,
		h = 16,
		layer = 2,
		alpha = 0.33,
		visible = true
	})
	local c_x,c_y = panel:center()
	icon:set_center_y(c_y)
	local amount_1 = panel:text({
		name = "amount_1",
		color = text_color,
		text = "00",
		font = "fonts/borda_semibold",
		font_size = 18, --12
		x = icon:right() + 1,
		y = 0, --1
		kern = -20,
		monospace = true,
		align = "left",
		vertical = "center", --"top"
		visible = false,
		layer = 2
	})
	local amount_2 = panel:text({
		name = "amount_2",
		color = text_color,
		text = "00",
		font = "fonts/borda_semibold",
		font_size = 12,
		x = icon:right() + 1,
		y = -1,
		kern = -20,
		monospace = true,
		align = "left",
		vertical = "bottom",
		layer = 2,
		visible = false
	})
	
	return panel
end

function SHDHUDPlayer.create_loadout_equipment_box(parent,name)
	if alive(parent:child(name)) then
		parent:remove(parent:child(name))
	end
	
	local icon_color = SHDHUDCore:get_color("player_hud_equipment_icon")
	local text_color = SHDHUDCore:get_color("player_hud_equipment_text")
	local highlight_color = SHDHUDCore:get_color("player_hud_highlight")
	
	local w = parent:w()/2
	local h = parent:h()
	local panel = parent:panel({
		name = name,
		w = w,
		h = h,
		valign = "grow",
		halign = "grow",
		false
	})
	
	local bg = panel:rect({
		name = "bg",
		color = highlight_color,
		alpha = 0.5,
		layer = 0,
		visible = false
	})
	
	local icon, texture_rect = tweak_data.hud_icons:get_icon_data("equipment_frag")
	local icon = panel:bitmap({
		name = "icon",
		texture = icon,
		texture_rect = texture_rect,
		color = icon_color,
		x = 0,
		w = 16,
		h = 16,
		layer = 2,
		visible = true
	})
	local c_x,c_y = panel:center()
	icon:set_center_y(c_y)
	local amount_1 = panel:text({
		name = "amount_1",
		color = text_color,
		text = "00",
		font = "fonts/borda_semibold",
		font_size = 18,
		x = icon:right() + 1,
		y = 0,
		kern = -20,
		monospace = true,
		align = "left",
		vertical = "center",
		layer = 2
	})
	
	return panel
end


function SHDHUDPlayer:init(master_panel,index,...)
	SHDHUDPlayer.super.init(self,master_panel,index,...)
	
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

function SHDHUDPlayer:create_hud()
	local hud_panel = self._panel
	
	local vitals = self:create_vitals()
	self._vitals_panel = vitals
	
	local weapons = self:create_weapons()
	self._weapons_panel = weapons
	
	local deployables_panel = self:create_deployables()
	self._deployables_panel = deployables_panel
	
	local loadout_equipment_panel = self:create_loadout_equipment()
	self._loadout_equipment_panel = loadout_equipment_panel
	
	
	local buffs_panel = self:create_buffs()
	self._buffs_panel = buffs_panel
	
end

function SHDHUDPlayer:create_vitals()
	local hud_panel = self._panel
	
	local hat_color = SHDHUDCore:get_color("player_hud_health_hat")
	local cradle_color = SHDHUDCore:get_color("player_hud_health_cradle")
	
	local base_h = 20
	local bonus_unfold_h = 4 + 4

	local vitals = hud_panel:panel({
		name = "vitals",
		w = 154,
		h = base_h + bonus_unfold_h,
		x = 0,
		y = bonus_unfold_h,
		valign = "grow",
		halign = "grow"
	})
	local vitals_debug = vitals:rect({
		name = "vitals_debug",
		color = Color.red,
		visible = DEBUG_VISIBLE,
		alpha = 0.1,
		valign = "grow",
		halign = "grow"
	})
	
	--[[
	local vitals_divider = vitals:gradient({
		name = "vitals_divider",
		orientation = "vertical",
		x = 0,
		y = 18,
		w = vitals:w(),
		h = 2,
		gradient_points = {
			0,Color.white:with_alpha(0.5),
			1,Color.white:with_alpha(0)
		},
		layer = 3,
		halign = "grow",
		valign = "bottom"
	})
	--]]
	
	local health_panel = vitals:panel({
		name = "health_panel",
		w = vitals:w(),
		h = 8,
--		y = armor_panel:bottom(),
		halign = "grow",
		valign = "grow"
	})
	health_panel:set_bottom(vitals:h())
	self._health_panel = health_panel
	
	--self:create_health_bar(health_panel,100)
	
	--[ [
	local health_debug = health_panel:rect({
		name = "health_debug",
		color = Color.blue,
		visible = DEBUG_VISIBLE,
		alpha = 0.5,
		valign = "grow",
		halign = "grow"
	})
	--]]
	local health_hat = health_panel:rect({
		name = "health_hat",
		color = hat_color,
		w = 2,
		h = 5,
		x = 150,
		y = 1,
		valign = "grow",
		halign = "grow",
		layer = 5
	})
	local health_cradle = health_panel:polyline({
		name = "health_cradle",
		color = cradle_color,
		x = 2,
		y = 4,
		points = {
			Vector3(0,0,0),
			Vector3(0,3,0),
			Vector3(health_hat:x(),3,0),
			Vector3(health_hat:x(),0,0)
		},
		valign = "bottom",
		halign = "grow",
		line_width = 1.1,
		closed = false,
		layer = 4
	})
	
	local armor_panel = vitals:panel({
		name = "armor_panel",
		w = vitals:w(),
		h = 8,
		halign = "grow",
		valign = "grow"
	})
	armor_panel:set_bottom(health_panel:y())
	self._armor_panel = armor_panel
	--self:create_armor_bar(armor_panel,100)
	
	--[ [
	
	local armor_debug = armor_panel:rect({
		name = "armor_debug",
		color = Color.green,
		visible = DEBUG_VISIBLE,
		alpha = 0.5,
		valign = "grow",
		halign = "grow"
	})
	--]]
	
	
	return vitals
end

function SHDHUDPlayer:create_armor_bar(panel,max_amount)
	local h_margin = 2
	local v_margin = 2
	
	local fg_color = SHDHUDCore:get_color("player_hud_health_bar_fg")
	local bg_color = SHDHUDCore:get_color("player_hud_health_bar_bg")
	local divider_color = SHDHUDCore:get_color("player_hud_dividers")
	local highlight_color = SHDHUDCore:get_color("player_hud_highlight")
	
	local max_w = panel:w() - (h_margin * 2)
	local max_h = 4
	
	local frame = panel:child("frame")
	if alive(frame) then
		panel:remove(frame)
		frame = nil
	end
	
	frame = panel:panel({
		name = "frame",
		x = h_margin,
		y = v_margin,
		w = max_w,
		h = max_h,
		valign = "grow",
		halign = "grow"
	})
	local frame_bg = panel:panel({
		name = "frame_bg",
		x = h_margin,
		y = v_margin,
		w = max_w,
		h = max_h,
		valign = "grow",
		halign = "grow"
	})
	local frame_fg = frame:rect({
		name = "frame_fg",
		color = highlight_color,
		x = 0,
		y = 0,
		w = max_w,
		h = max_h,
		halign = "grow",
		valign = "grow",
		layer = 9,
		alpha = 0.25,
		visible = false
	})
	
	if self.config.use_armor_segments then
		local segment_group_size = self.config.armor_segment_group_size
		local minor_ratio = self.config.armor_segment_margin_small
		local major_ratio = self.config.armor_segment_margin_large
		local segment_amount = self.config.armor_segment_amount
		local DISPLAY_MUL = tweak_data.gui.stats_present_multiplier
		
		local f_num_segments = DISPLAY_MUL * max_amount / segment_amount
		--local num_segments_min = math.max(math.floor(f_num_segments) - 1,1)
		local num_segments_max = math.max(math.ceil(f_num_segments),1)
		local num_segments_maj = math.floor(num_segments_max / segment_group_size)
		-- number of major margins that must be added
		local f_segment_w = max_w / (((num_segments_max - num_segments_maj) * (1 + minor_ratio)) + (num_segments_maj * major_ratio))
		local segment_w = math.floor(f_segment_w)
		self.data.armor_segment_w = segment_w
		-- minor segments amount should not count major segments when applying margin
		
		local minor_margin = math.floor(minor_ratio * f_segment_w)
		local major_margin = math.floor(major_ratio * f_segment_w)
		--Print("Minor segments:",num_segments_max,"Major segments:",num_segments_maj,"Segment w:",segment_w)
		
		local x = 0
		for i = 1,num_segments_max,1 do
			local segment = frame:rect({
				name = string.format("segment_%i",i),
				color = fg_color,
				x = x,
				y = 0,
				w = segment_w,
				h = max_h,
				halign = "grow",
				valign = "grow",
				layer = 2,
				rotation = 0.001,
				alpha = 1
			})
			local segment_bg = frame_bg:rect({
				name = string.format("segment_%i_bg",i),
				color = bg_color,
				x = x,
				y = 0,
				w = segment_w,
				h = max_h,
				halign = "grow",
				valign = "grow",
				rotation = 0.001,
				layer = -1,
				alpha = 0.25
			})
			if i == num_segments_max then
				local remainder_w = max_w - x
				if remainder_w > 0 then
					self.data.armor_segment_remainder_w = remainder_w
					segment:set_w(remainder_w)
					segment_bg:set_w(remainder_w)
				else
					segment:set_w(0)
					segment_bg:set_w(0)
				end
			elseif i == num_segments_max - 1 and num_segments_max > 2 then
				x = x + segment_w
			elseif i % segment_group_size == 0 then
				x = x + major_margin + segment_w
			else
				x = x + minor_margin + segment_w
			end
		end
		self.data.armor_segments_total = num_segments_max
	else
		local segment = frame:rect({
			name = "segment_1",
			color = fg_color,
			x = 0,
			y = 0,
			w = max_w,
			h = max_h,
			halign = "grow",
			valign = "grow",
			layer = 2,
			alpha = 1
		})
		local segment_bg = frame_bg:rect({
			name = "segment_1_bg",
			color = bg_color,
			x = 0,
			y = 0,
			w = max_w,
			h = max_h,
			halign = "grow",
			valign = "grow",
			layer = -1,
			alpha = 0.25
		})
		self.data.armor_segment_remainder_w = max_w
		self.data.armor_segments_total = 1
	end
	
	if self.data.is_armor_bar_unfolded then
		self:unfold_armor_bar()
	--else
		--self:fold_armor_bar()
	end
	
	return frame
end

function SHDHUDPlayer:create_health_bar(panel,max_amount)
	local h_margin = 2
	local v_margin = 2
	
	local fg_color = SHDHUDCore:get_color("player_hud_health_bar_fg")
	local bg_color = SHDHUDCore:get_color("player_hud_health_bar_bg")
	local divider_color = SHDHUDCore:get_color("player_hud_dividers")
	local highlight_color = SHDHUDCore:get_color("player_hud_highlight")
	
	local max_w = panel:w() - (h_margin * 2)
	local max_h = 4
	
	local frame = panel:child("frame")
	if alive(frame) then
		panel:remove(frame)
		frame = nil
	end
	
	frame = panel:panel({
		name = "frame",
		x = h_margin,
		y = v_margin,
		w = max_w,
		h = max_h,
		valign = "grow",
		halign = "grow"
	})
	
	local frame_bg = panel:panel({
		name = "frame_bg",
		x = h_margin,
		y = v_margin,
		w = max_w,
		h = max_h,
		valign = "grow",
		halign = "grow"
	})
	
	local frame_fg = frame:rect({
		name = "frame_fg",
		color = highlight_color,
		x = 0,
		y = 0,
		w = max_w,
		h = max_h,
		halign = "grow",
		valign = "grow",
		layer = 9,
		alpha = 0.25,
		visible = false
	})
	
	if self.config.use_health_segments then
		local segment_group_size = self.config.health_segment_group_size
		local minor_ratio = self.config.health_segment_margin_small
		local major_ratio = self.config.health_segment_margin_large
		local segment_amount = self.config.health_segment_amount
		local DISPLAY_MUL = tweak_data.gui.stats_present_multiplier
		
		local f_num_segments = DISPLAY_MUL * max_amount / segment_amount
		local num_segments_max = math.max(math.ceil(f_num_segments),1)
		local num_segments_maj = math.floor(num_segments_max / segment_group_size)
		local f_segment_w = max_w / (((num_segments_max - num_segments_maj) * (1 + minor_ratio)) + (num_segments_maj * major_ratio))
		local segment_w = math.floor(f_segment_w)
		self.data.health_segment_w = segment_w
		
		local minor_margin = math.floor(minor_ratio * f_segment_w)
		local major_margin = math.floor(major_ratio * f_segment_w)
		
		local x = 0
		for i = 1,num_segments_max,1 do
			local segment = frame:rect({
				name = string.format("segment_%i",i),
				color = fg_color,
				x = x,
				y = 0,
				w = segment_w,
				h = max_h,
				halign = "grow",
				valign = "grow",
				rotation = 0.001,
				layer = 2,
				alpha = 1
			})
			local segment_bg = frame_bg:rect({
				name = string.format("segment_%i_bg",i),
				color = bg_color,
				x = x,
				y = 0,
				w = segment_w,
				h = max_h,
				halign = "grow",
				valign = "grow",
				rotation = 0.001,
				layer = -1,
				alpha = 0.25
			})
			if i == num_segments_max then
				local remainder_w = max_w - x
				if remainder_w > 0 then
					self.data.health_segment_remainder_w = remainder_w
					segment:set_w(remainder_w)
					segment_bg:set_w(remainder_w)
				else
					segment:set_w(0)
				end
			elseif i == num_segments_max - 1 then
				x = x + segment_w
			elseif i % segment_group_size == 0 then
				x = x + major_margin + segment_w
			else
				x = x + minor_margin + segment_w
			end
		end
		self.data.health_segments_total = num_segments_max
	else
		local segment = frame:rect({
			name = "segment_1",
			color = fg_color,
			x = 0,
			y = 0,
			w = max_w,
			h = max_h,
			halign = "grow",
			valign = "grow",
			layer = 2,
			alpha = 1
		})
		local segment_bg = frame_bg:rect({
			name = "segment_1_bg",
			color = bg_color,
			x = 0,
			y = 0,
			w = max_w,
			h = max_h,
			halign = "grow",
			valign = "grow",
			layer = -1,
			alpha = 0.25
		})
		self.data.health_segment_remainder_w = max_w
		self.data.health_segments_total = 1
	end
	
	if self.data.is_health_bar_unfolded then
		self:unfold_health_bar()
	--else
		--self:fold_health_bar()
	end
	
	return frame
end

function SHDHUDPlayer:create_weapons()
	local hud_panel = self._panel
	local vitals = self._vitals_panel
	
	local divider_color = SHDHUDCore:get_color("player_hud_dividers")
	local highlight_color = SHDHUDCore:get_color("player_hud_highlight")
	
	local weapons = hud_panel:panel({
		name = "weapons",
		w = 72,
		h = 48,
		x = 0,
		y = vitals:bottom()
	})
	local weapons_divider_top = weapons:gradient({
		name = "weapons_divider_top",
		orientation = "vertical",
		x = 0,
		y = 0,
		w = weapons:w(),
		h = 2,
		gradient_points = {
			0,divider_color:with_alpha(0),
			1,divider_color:with_alpha(0.5)
		},
		layer = 3,
		halign = "grow",
		valign = "top"
	})
	local weapons_divider_bottom = weapons:gradient({
		name = "weapons_divider_bottom",
		orientation = "vertical",
		x = 0,
		y = weapons:h() - 2,
		w = weapons:w(),
		h = 2,
		gradient_points = {
			0,divider_color:with_alpha(0.5),
			1,divider_color:with_alpha(0)
		},
		halign = "grow",
		valign = "bottom"
	})
	self.add_blur_bg(weapons)
	
	local equipped_weapon_panel = weapons:panel({
		name = "equipped_weapon_panel",
		y = 0,
		w = 44,
		h = 48
	})
	local equipped_weapon_fg = equipped_weapon_panel:rect({
		name = "equipped_weapon_fg",
		color = highlight_color,
		w = equipped_weapon_panel:w(),
		h = equipped_weapon_panel:h(),
		valign = "grow",
		halign = "grow",
		alpha = 0.5,
		layer = 0,
		visible = false
	})
	local equipped_weapon_divider_right = equipped_weapon_panel:gradient({
		name = "equipped_weapon_divider_right",
		orientation = "horizontal",
		x = 42,
		y = 2,
		w = 2,
		h = 44,
		alpha = 0.5,
		gradient_points = {
			0,divider_color:with_alpha(0),
			1,divider_color:with_alpha(0.5)
		},
		layer = 3,
		halign = "right",
		valign = "grow"
	})
	local mag_label = equipped_weapon_panel:text({
		name = "mag_label",
		color = Color.white,
		text = "99",
		y = -2,
		kern = -18,
		monospace = true,
		align = "center",
--		align = "center",
--		vertical = "center",
		font = "fonts/borda_semibold",
		font_size = 32,
		layer = 1
	})
	local reserve_label = equipped_weapon_panel:text({
		name = "reserve_label",
		color = Color("aaaaaa"),
		text = "000",
		font = "fonts/borda_semibold",
		font_size = 20,
		y = 24,
		kern = -18,
		monospace = true,
		align = "center",
		vertical = "top",
--		align = "center",
--		vertical = "center",
		layer = 1
	})
	
	
	local backpack_weapons_panel = weapons:panel({
		name = "backpack_weapons_panel",
		x = equipped_weapon_panel:right(),
		y = 0,
		w = weapons:w() - equipped_weapon_panel:w(),
		h = 50
	})
	local backpack_weapons_panel_blur = backpack_weapons_panel:bitmap({
		name = "backpack_weapons_panel_blur",
		texture = "guis/textures/test_blur_df",
		render_template = "VertexColorTexturedBlur3D",
		color = Color(1,1,1),
		w = backpack_weapons_panel:w(),
		h = backpack_weapons_panel:h(),
		valign = "grow",
		halign = "grow",
		layer = 0,
		visible = false
	})
	local backpack_weapon_label_1 = self.create_backpack_label(backpack_weapons_panel,"backpack_weapon_label_1")
	--backpack_weapon_label_1:set_y(2)
	local backpack_weapon_label_2 = self.create_backpack_label(backpack_weapons_panel,"backpack_weapon_label_2")
	backpack_weapon_label_2:set_y(backpack_weapon_label_1:bottom())
	local backpack_weapon_label_3 = self.create_backpack_label(backpack_weapons_panel,"backpack_weapon_label_3")
	backpack_weapon_label_3:set_y(backpack_weapon_label_2:bottom())
	return weapons
end

function SHDHUDPlayer:create_deployables()
	local hud_panel = self._panel
	local weapons = self._weapons_panel
	
	local divider_color = SHDHUDCore:get_color("player_hud_dividers")
	
	local deployables_panel = hud_panel:panel({
		name = "deployables_panel",
		w = 78,
		h = 24,
		x = weapons:right() + 2,
		y = weapons:y()
	})
	local deployables_panel_blur = deployables_panel:rect({
		name = "deployables_panel_debug",
		color = Color.white,
		w = deployables_panel:w(),
		h = deployables_panel:h(),
		valign = "grow",
		halign = "grow",
		layer = 0,
		visible = false
	})
	local deployables_panel_divider_top = deployables_panel:gradient({
		name = "deployables_panel_divider_top",
		orientation = "vertical",
		x = 0,
		y = 0,
		w = deployables_panel:w(),
		h = 2,
		gradient_points = {
			0,divider_color:with_alpha(0),
			1,divider_color:with_alpha(0.5)
		},
		layer = 3,
		halign = "grow",
		valign = "top"
	})
	local deployables_panel_divider_bottom = deployables_panel:gradient({
		name = "deployables_panel_divider_bottom",
		orientation = "vertical",
		x = 0,
		y = deployables_panel:h() - 2,
		w = deployables_panel:w(),
		h = 2,
		alpha = 0.5,
		gradient_points = {
			0,divider_color:with_alpha(0.5),
			1,divider_color:with_alpha(0)
		},
		layer = 3,
		halign = "grow",
		valign = "bottom"
	})
	self.add_blur_bg(deployables_panel)
	
	local deployable_1 = SHDHUDPlayer.create_deployable_box(deployables_panel,"deployable_1")
	self.add_progress_bg(deployable_1)
	local deployable_2 = SHDHUDPlayer.create_deployable_box(deployables_panel,"deployable_2")
	self.add_progress_bg(deployable_2)
	deployable_2:set_x(deployable_1:right())
	return deployables_panel
end

function SHDHUDPlayer:create_loadout_equipment()
	local hud_panel = self._panel
	local deployables_panel = self._deployables_panel
	
	local divider_color = SHDHUDCore:get_color("player_hud_dividers")
	local highlight_color = SHDHUDCore:get_color("player_hud_highlight")
	
	local loadout_equipment_panel = hud_panel:panel({
		name = "loadout_equipment_panel",
		w = 78,
		h = 22,
		x = deployables_panel:x(),
		y = deployables_panel:bottom() + 2
	})
	local loadout_equipment_panel_rect = loadout_equipment_panel:rect({
		name = "loadout_equipment_panel_rect",
		color = highlight_color,
		w = loadout_equipment_panel:w(),
		h = loadout_equipment_panel:h(),
		valign = "grow",
		halign = "grow",
		layer = 0,
		visible = false
	})
	
	local loadout_equipment_panel_divider_top = loadout_equipment_panel:gradient({
		name = "loadout_equipment_panel_divider_top",
		orientation = "vertical",
		x = 0,
		y = 0,
		w = loadout_equipment_panel:w(),
		h = 2,
		gradient_points = {
			0,divider_color:with_alpha(0),
			1,divider_color:with_alpha(0.5)
		},
		layer = 3,
		halign = "grow",
		valign = "top"
	})
	local loadout_equipment_panel_divider_bottom = loadout_equipment_panel:gradient({
		name = "loadout_equipment_panel_divider_bottom",
		orientation = "vertical",
		x = 0,
		y = loadout_equipment_panel:h() - 2,
		w = loadout_equipment_panel:w(),
		h = 2,
		alpha = 0.5,
		gradient_points = {
			0,divider_color:with_alpha(0.5),
			1,divider_color:with_alpha(0)
		},
		layer = 3,
		halign = "grow",
		valign = "bottom"
	})
	self.add_blur_bg(loadout_equipment_panel)
	local throwable = self.create_loadout_equipment_box(loadout_equipment_panel,"throwables")
	do
		local icon,rect = tweak_data.hud_icons:get_icon_data("frag_grenade")
		throwable:child("icon"):set_image(icon,unpack(rect))
		self.add_progress_bg(throwable)
	end
	local cableties = self.create_loadout_equipment_box(loadout_equipment_panel,"cableties")
	do
		local icon,rect = tweak_data.hud_icons:get_icon_data("equipment_cable_ties")
		cableties:child("icon"):set_image(icon,unpack(rect))
	end
	cableties:set_x(throwable:right())
	return loadout_equipment_panel
end

function SHDHUDPlayer:create_buffs()
	local hud_panel = self._panel
	local weapons = self._weapons_panel
	
	local buffs_panel = hud_panel:panel({
		name = "buffs_panel",
		w = 152,
		h = 64,
		x = 0,
		y = weapons:bottom() + 2
	})
	local buffs_panel_debug = buffs_panel:rect({
		name = "buffs_panel_debug",
		color = Color(1,0.5,0),
		visible = DEBUG_VISIBLE,
		alpha = 0.2,
		valign = "grow",
		halign = "grow"
	})
	
	return buffs_panel
end

function SHDHUDPlayer:set_weapon_selected(id,hud_icon)
	if self.data.equipped_weapon_index ~= id then
		self.data.equipped_weapon_index = id
		--self:upd_ammo_amount(id)
		self:upd_backpack_ammo(id)
	end
end

-- update magazine count of stowed weapon
function SHDHUDPlayer:upd_backpack_ammo(equipped_index)		
	local color_full = SHDHUDCore:get_color("player_hud_loadout_full")
	local color_empty = SHDHUDCore:get_color("player_hud_loadout_empty_1")
	local color_partial = SHDHUDCore:get_color("player_hud_loadout_empty_2")
	
	local MAX_DIGITS = 2
	local backpack_slot = 0
	for selection_index = 1,table.size(self.data.weapons),1 do 
		local ammo_data = self.data.weapons[selection_index]
		if ammo_data and selection_index ~= equipped_index then
			backpack_slot = backpack_slot + 1
			local backpack_panel = self._weapons_panel:child("backpack_weapons_panel"):child(string.format("backpack_weapon_label_%i",backpack_slot))
			if alive(backpack_panel) then
				backpack_panel:show()
				self.set_number_label(backpack_panel:child("label"),ammo_data.magazine_current or 0,MAX_DIGITS,{
					color_full,
					color_empty,
					color_partial
				})
				
				--break -- temp; only show loaded mag values for primary/secondary weapons (selection index 1 or 2)
			else
				break
			end
		end
	end
end

-- do not use
function SHDHUDPlayer:upd_ammo_amount(selection_index)
	local ammo_data = self.data.weapons[selection_index]
	if ammo_data then
		local magazine_current = ammo_data.magazine_current
		local magazine_max = ammo_data.magazine_max
		local reserve_current = ammo_data.reserve_current
		local reserve_max = ammo_data.reserve_max
		if self._alt_ammo then
			reserve_current = math.max(0, reserve_current - magazine_max - (magazine_current - magazine_max))
		end
		self:set_magazine_amount(selection_index,magazine_current,magazine_max)
		self:set_reserve_amount(selection_index,reserve_current,reserve_max)
	end
end

function SHDHUDPlayer:set_ammo_amount(selection_index,max_clip,current_clip,current_left,max_left)
	local wpns_data = self.data.weapons[selection_index]
	if wpns_data then
		wpns_data.magazine_max = max_clip or wpns_data.magazine_max
		wpns_data.magazine_current = current_clip or wpns_data.magazine_current
		wpns_data.reserve_max = max_left or wpns_data.reserve_max
		wpns_data.reserve_current = current_left or wpns_data.reserve_current
	else
		self.data.weapons[selection_index] = {
			magazine_current = current_clip or 0,
			magazine_max = max_clip or 0,
			reserve_current = current_left or 0,
			reserve_max = max_left or 0
		}
	end
	if selection_index == self.data.equipped_weapon_index then
		self:set_magazine_amount(selection_index,current_clip,max_clip)
		self:set_reserve_amount(selection_index,current_left,max_left)
		--self:upd_ammo_amount(selection_index)
	end
end

function SHDHUDPlayer:set_magazine_amount(slot,current,total)
	self:_set_magazine_amount(slot,current,total)
end

function SHDHUDPlayer:_set_magazine_amount(slot,current,total)
	local weapons = self._weapons_panel
	local equipped_weapon_panel = weapons:child("equipped_weapon_panel")
	local mag_label = equipped_weapon_panel:child("mag_label")
	local NUM_DIGITS = 2
	
	local full_color = SHDHUDCore:get_color("player_hud_ammo_magazine_full")
	local partial_color = SHDHUDCore:get_color("player_hud_ammo_magazine_empty_2")
	local empty_color = SHDHUDCore:get_color("player_hud_ammo_magazine_empty_1")
	self.set_number_label(mag_label,current,NUM_DIGITS,{full_color,empty_color,partial_color})
end

function SHDHUDPlayer:set_reserve_amount(slot,current,total)
	self:_set_reserve_amount(slot,current,total)
end

function SHDHUDPlayer:_set_reserve_amount(slot,current,total)
	local weapons = self._weapons_panel
	local equipped_weapon_panel = weapons:child("equipped_weapon_panel")
	local reserve_label = equipped_weapon_panel:child("reserve_label")
	local NUM_DIGITS = 3
	
	local full_color = SHDHUDCore:get_color("player_hud_ammo_reserve_full")
	local empty_color = SHDHUDCore:get_color("player_hud_ammo_reserve_empty_1")
	self.set_number_label(reserve_label,current,NUM_DIGITS,{full_color,empty_color})
end

function SHDHUDPlayer:set_backpack_amount(slot,current,total)
	local weapons = self._weapons_panel
	local backpack_weapons_panel = weapons:child("backpack_weapons_panel")
	local reserve = backpack_weapons_panel:child(string.format("backpack_weapon_label_%i",slot))
	local NUM_DIGITS = 2
	if alive(reserve) then
		self.set_number_label(reserve:child("label"),current,NUM_DIGITS,nil)
	end
end

function SHDHUDPlayer:set_health(data)
	if data.total ~= self.data.health_total then
		self.data.health_total = data.total
		local frame = self:create_health_bar(self._health_panel,data.total)
		if data.total == 0 then
			frame:hide()
		end
	end
	local DISPLAY_MUL = tweak_data.gui.stats_present_multiplier
	self:_set_health(DISPLAY_MUL * data.current,DISPLAY_MUL * data.total,data.revives)
end

function SHDHUDPlayer:_set_health(current,total,revives)
	if total > 0 then
		if current < 1 then
			current = 0
			-- >:( BAD INTERPOLATION! BAD! NO BISCUIT!
		end
		local health_panel = self._health_panel
		local frame = health_panel:child("frame")
		
		local is_low = self.config.health_low_threshold and current/total < self.config.health_low_threshold -- if low health (less than 25%)
		local prev_is_low = self.data.low_health_anim and true or false
		if is_low and not prev_is_low then
			self.data.low_health_anim = frame:animate(SHDAnimLibrary.animate_flash_alpha,nil,2,0.15,0.8)
		elseif not is_low and prev_is_low then
			frame:stop(self.data.low_health_anim)
			self.data.low_health_anim = nil
			frame:set_alpha(1)
		end
		
		local segments_total = self.data.health_segments_total
		if segments_total == 1 then
			local segment = frame:child("segment_1")
			if alive(segment) then
				local segment_w = self.data.health_segment_remainder_w
				segment:set_w(segment_w * current / total)
				health_panel:child("health_hat"):set_x(segment:right())
				if is_low and not prev_is_low then
					segment:set_color(Color.red)
				elseif prev_is_low and not is_low then
					segment:set_color(Color.white)
				end
			end
		else
			local segment_amount = self.config.health_segment_amount
			
			local segments_filled = math.floor(current/segment_amount)
			local current_remainder = current % segment_amount
			local max_remainder = total % segment_amount
			local remainder_ratio = current_remainder / max_remainder
			
			for i=segments_total,1,-1 do 
				local segment = frame:child(string.format("segment_%i",i))
				if alive(segment) then
					if i == segments_filled + 1 then
						if i == segments_total then
							-- last segment (likely irregular sized segment)
							segment:set_w(self.data.health_segment_remainder_w * remainder_ratio)
						else
							-- last semifilled segment (likely partially filled)
							segment:set_w(segment_w * current_remainder / segment_amount)
						end
					elseif i <= segments_filled then
						-- filled segment
						segment:set_w(segment_w)
					else
						-- empty segment
						segment:set_w(0)
					end
					
					if is_low and not prev_is_low then
						segment:set_color(Color.red)
					elseif prev_is_low and not is_low then
						segment:set_color(Color("ff8000"))
					end
				end
			end
		end
		if current >= total then
			if self.data.is_health_bar_unfolded then
				self:fold_health_bar()
			end
		else
			if not self.data.is_health_bar_unfolded then
				self:unfold_health_bar()
			end
		end
	end
end

function SHDHUDPlayer:set_revives_amount(amount)
	
end

function SHDHUDPlayer:set_armor(data)
	if data.total ~= self.data.armor_total then
		self.data.armor_total = data.total
		local frame = self:create_armor_bar(self._armor_panel,data.total)
		if data.total == 0 then
			frame:hide()
		end
	end
	-- todo animate set armor
	local DISPLAY_MUL = tweak_data.gui.stats_present_multiplier
	self:_set_armor(data.current * DISPLAY_MUL,data.total * DISPLAY_MUL)
end

function SHDHUDPlayer:_set_armor(current,total)
	if total > 0 then
		if current < 1 then
			current = 0
			-- >:( BAD INTERPOLATION! BAD! NO BISCUIT!
		end
		
		local frame = self._armor_panel:child("frame")
		
		local is_low = self.config.armor_low_threshold and current/total < self.config.armor_low_threshold -- if low armor (less than 25%)
		local prev_is_low = self.data.low_armor_anim and true or false
		if is_low and not prev_is_low then
			self.data.low_armor_anim = frame:animate(SHDAnimLibrary.animate_flash_alpha,nil,2,0.15,0.8)
		elseif not is_low and prev_is_low then
			frame:stop(self.data.low_armor_anim)
			self.data.low_armor_anim = nil
			frame:set_alpha(1)
		end
		
		local segments_total = self.data.armor_segments_total
		if segments_total == 1 then
			local segment = frame:child("segment_1")
			if alive(segment) then
				local segment_w = self.data.armor_segment_remainder_w
				segment:set_w(segment_w * current / total)
				if is_low and not prev_is_low then
					segment:set_color(Color.red)
				elseif prev_is_low and not is_low then
					segment:set_color(Color.white)
				end
			end
		else
			local segment_amount = self.config.armor_segment_amount
			--local segments_total = math.ceil(total / segment_amount)
			local segments_filled = math.floor(current/segment_amount)
			local current_remainder = current % segment_amount
			local max_remainder = total % segment_amount
			local remainder_ratio = current_remainder / max_remainder
			--Print("filled sasegments",segments_filled,"/",segments_total)
			local segment_w = self.data.armor_segment_w
			for i=segments_total,1,-1 do 
				local segment = frame:child(string.format("segment_%i",i))
				if alive(segment) then
					if i == segments_filled + 1 then
						if i == segments_total then
							-- last segment (likely irregular sized segment)
							segment:set_w(self.data.armor_segment_remainder_w * remainder_ratio)
						else
							-- last semifilled segment (likely partially filled)
							segment:set_w(segment_w * current_remainder / segment_amount)
						end
					elseif i <= segments_filled then
						-- filled segment
						segment:set_w(segment_w)
					else
						-- empty segment
						segment:set_w(0)
					end
					
					if is_low and not prev_is_low then
						segment:set_color(Color.red)
					elseif prev_is_low and not is_low then
						segment:set_color(Color.white)
					end
				end
			end
		end
	end
end

function SHDHUDPlayer.animate_grow_armor_bar(o,duration,to_h,b_y)
	local from_h = o:h()
	local delta_h = to_h - from_h
	local t,dt = 0,0
	
	while t < duration do 
		local dt = coroutine.yield()
		t = t + dt
		local interp = math.pow(t/duration,2)
		
		o:set_h(from_h + (delta_h * interp))
		o:set_bottom(b_y)
	end
	
	o:set_h(to_h)
	o:set_bottom(b_y)
end

function SHDHUDPlayer:fold_armor_bar()
	local frame = self._armor_panel --:child("frame")
	
	
	local duration = 0.33
	local to_h = 8
	local bottom_y = self._health_panel:y()
	
	frame:animate(self.animate_grow_armor_bar,duration,to_h,bottom_y)
	
	self.data.is_armor_bar_unfolded = false
end

function SHDHUDPlayer:unfold_armor_bar()
	local frame = self._armor_panel --:child("frame")
	local duration = 0.33
	local to_h = 12
	local bottom_y = self._health_panel:y()
	
	frame:animate(self.animate_grow_armor_bar,duration,to_h,bottom_y)
	
	self.data.is_armor_bar_unfolded = true
end

function SHDHUDPlayer.animate_grow_health_bar(o,duration,to_h,b_y,o2)
	local from_h = o:h()
	local delta_h = to_h - from_h
	local t,dt = 0,0
	
	while t < duration do 
		local dt = coroutine.yield()
		t = t + dt
		local interp = math.pow(t/duration,2)
		
		o:set_h(from_h + (delta_h * interp))
		o:set_bottom(b_y)
		o2:set_bottom(o:y())
	end
	
	o:set_h(to_h)
	o:set_bottom(b_y)
	o2:set_bottom(o:y())
end

function SHDHUDPlayer:fold_health_bar()
	local frame = self._health_panel --:child("frame")
	local duration = 0.33
	local to_h = 8
	local bottom_y = self._vitals_panel:h()
	
	frame:animate(self.animate_grow_health_bar,duration,to_h,bottom_y,self._armor_panel)
	
	self.data.is_health_bar_unfolded = false
end

function SHDHUDPlayer:unfold_health_bar()
	local frame = self._health_panel --:child("frame")
	local duration = 0.33
	local to_h = 12
	local bottom_y = self._vitals_panel:h()
	
	frame:animate(self.animate_grow_health_bar,duration,to_h,bottom_y,self._armor_panel)

	self.data.is_health_bar_unfolded = true
end


function SHDHUDPlayer:add_deployable(data)
	self:set_deployable_icon(data)
	self:set_deployable_amount(data)
end

function SHDHUDPlayer:set_deployable_icon(data)
	self:_set_deployable_icon(data.slot or 1,data.icon)
end

function SHDHUDPlayer:_set_deployable_icon(slot,id)
	local panel = self._deployables_panel:child(string.format("deployable_%s",slot))
	if alive(panel) then
		local texture, texture_rect = tweak_data.hud_icons:get_icon_data(id)
		local icon = panel:child("icon")
		icon:set_image(texture,unpack(texture_rect))
		panel:show()
	end
end

function SHDHUDPlayer:set_deployable_amount(data)
	local amount_type = type(data.amount)
	if amount_type == "table" then
		self:_set_deployable_amount(data.slot or 1,data.amount[1],data.amount[2])
	elseif amount_type == "number" then
		self:_set_deployable_amount(data.slot or 1,data.amount)
	elseif amount_type == "nil" then
		error("Nil amount to SHDHUDPlayer:set_deployable_amount()")
	else
		error("Unknown amount type to SHDHUDPlayer:set_deployable_amount(): " .. tostring(data.amount))
	end
end

function SHDHUDPlayer:_set_deployable_amount(slot,amount1,amount2)
	local panel = self._deployables_panel:child(string.format("deployable_%s",slot))
	
	local color_full = SHDHUDCore:get_color("player_hud_deployable_full")
	local color_empty = SHDHUDCore:get_color("player_hud_deployable_empty_1")
	local color_partial = SHDHUDCore:get_color("player_hud_deployable_empty_2")
	
	if alive(panel) then
		local MAX_DIGITS = 2
		local label_1 = panel:child("amount_1")
		local label_2 = panel:child("amount_2")
		if amount1 then
			if (amount2 == 0 or not amount2) and amount1 == 0 then
				panel:child("icon"):set_alpha(0.33)
			else
				panel:child("icon"):set_alpha(1)
			end
			
			self.set_number_label(label_1,amount1,MAX_DIGITS,{
				color_full,
				color_empty,
				color_partial
			})
			
			label_1:show()
		end
		if amount2 then
			self.set_number_label(label_2,amount2,MAX_DIGITS,{
				color_full,
				color_empty,
				color_partial
			})
			
			if amount2 ~= 0 then
				label_1:set_vertical("top")
				label_1:set_font_size(12)
				label_1:set_y(1)
				
				label_2:show()
			else
				label_1:set_vertical("center")
				label_1:set_font_size(18)
				label_1:set_y(0)
				
				label_2:hide()
			end
		end
		panel:show()
	end
end

function SHDHUDPlayer:switch_deployable(prev_index,new_index)
	if prev_index and prev_index ~= new_index then
		local deployable_prev = self._deployables_panel:child(string.format("deployable_%s",prev_index))
		if alive(deployable_prev) then
			deployable_prev:animate(SHDAnimLibrary.animate_alpha_sq,0.33,0.5)
		end
	end
	if new_index then
		local deployable_new = self._deployables_panel:child(string.format("deployable_%s",new_index))
		if alive(deployable_new) then
			deployable_new:animate(SHDAnimLibrary.animate_alpha_sq,0.33,1)
		end
	end
end


function SHDHUDPlayer:add_cable_ties(data)
	local cable_ties = self._loadout_equipment_panel:child("cableties")
	--local cable_ties = self._loadout_equipment_panel:child("throwables")
	
	cable_ties:child("amount_1")
	
	local texture, texture_rect = tweak_data.hud_icons:get_icon_data(data.icon)
	cable_ties:child("icon"):set_image(texture,unpack(texture_rect))
	cable_ties:show()
	
	self:set_cable_ties(data.amount)
end

function SHDHUDPlayer:set_cable_ties(amount)
	local cable_ties = self._loadout_equipment_panel:child("cableties")
	local MAX_DIGITS = 2
	
	local color_full = SHDHUDCore:get_color("player_hud_loadout_full")
	local color_empty = SHDHUDCore:get_color("player_hud_loadout_empty_1")
	local color_partial = SHDHUDCore:get_color("player_hud_loadout_empty_2")
	
	self.set_number_label(cable_ties:child("amount_1"),amount,MAX_DIGITS,{
		color_full,
		color_empty,
		color_partial
	})
	
	local empty_alpha = 0.33
	local full_alpha = 1
	cable_ties:child("icon"):set_alpha(amount == 0 and empty_alpha or full_alpha)
end


function SHDHUDPlayer:set_grenades(data)
	if not PlayerBase.USE_GRENADES then
		return
	end
	local throwables = self._loadout_equipment_panel:child("throwables")
	
	local texture, texture_rect = tweak_data.hud_icons:get_icon_data(data.icon, {
		0,
		0,
		32,
		32
	})
	
	throwables:child("icon"):set_image(texture,unpack(texture_rect))
	
	self:set_grenades_amount(data)
end

function SHDHUDPlayer:set_grenades_amount(data)
	if not PlayerBase.USE_GRENADES then
		return
	end
	local throwables = self._loadout_equipment_panel:child("throwables")
	
	local MAX_DIGITS = 2
	local color_full = SHDHUDCore:get_color("player_hud_loadout_full")
	local color_empty = SHDHUDCore:get_color("player_hud_loadout_empty_1")
	local color_partial = SHDHUDCore:get_color("player_hud_loadout_empty_2")
	
	self.set_number_label(throwables:child("amount_1"),data.amount,MAX_DIGITS,{
		color_full,
		color_empty,
		color_partial
	})
	
	local empty_alpha = 0.33
	local full_alpha = 1
	throwables:child("icon"):set_alpha(data.amount == 0 and empty_alpha or full_alpha)
end

function SHDHUDPlayer:set_grenade_cooldown(data)
	local throwables = self._loadout_equipment_panel:child("throwables")
	local progress_bg = throwables:child("progress_bg")
	local progress_bobber = throwables:child("progress_bobber")
	-- start animate grenade cooldown (gradient)
	
	progress_bg:stop()
	
	local function animate_recharge(o,duration,end_time,frequency,min_a,max_a,color_1,color_2)
		o:show()
		
		color_1 = color_1 or Color("5c5c5c") -- main color
		color_2 = color_2 or Color("ffffff") -- pulse color
		local color_delta = color_2 - color_1
		local color_transparent = color_1:with_alpha(0)
		local delta_a = max_a - min_a
		local t = 0
		repeat 
			local now = managers.game_play_central:get_heist_timer()
			local time_left = end_time - now
			local progress = math.clamp(1 - time_left / duration, 0, 1)
			
			local t_rad = 180 * t
			local pulse_t = (1 - math.cos(t_rad / frequency)) / 2
			
			o:set_alpha(min_a + (delta_a * pulse_t))
			
			local color_lerp = color_1 + (color_delta * pulse_t)
			local lerp_mid
			if math.sin(t_rad) / frequency <= 0 then
				lerp_mid = progress
			else
				lerp_mid = progress * pulse_t
			end
		
			o:set_gradient_points({
				0,
				color_1,
				
				lerp_mid,
				color_lerp,
				
				lerp_mid+0.01,
				color_1,
				
				progress,
				color_1,
				
				progress+0.01,
				color_transparent,
				
				1,
				color_transparent
			})
			t = t + coroutine.yield()
		until time_left <= 0
		o:hide()
	end
	
	local end_time = data and data.end_time
	local duration = data and data.duration
	
	if not end_time or not duration then
		-- stop animation
		-- set cooldown to 0
		progress_bg:hide()
		return
	end
	local frequency = 1
	
	local color_1 = nil
	local color_2 = nil
	local min_a = 0.33
	local max_a = 0.5
	
	progress_bg:animate(animate_recharge,duration,end_time,frequency,min_a,max_a,color_1,color_2)
	--SHDAnimLibrary.animate_gradient_recharge(throwables:child("progress_bg"),throwables:child("progress_bobber"),duration,frequency,color_1,color_2)
	
	managers.network:session():send_to_peers("sync_grenades_cooldown", end_time, duration)
end

function SHDHUDPlayer:set_ability_icon(icon)
	-- the icon that appears in the center of the health radial, while an ability is active
end

function SHDHUDPlayer:activate_ability_radial(time_left,time_total)
	-- start radial ability active duration animation
	time_total = time_total or time_left
	local throwables = self._loadout_equipment_panel:child("throwables")
	local bg = throwables:child("bg")
	bg:set_w(throwables:w() * time_left / time_total)
	bg:show()
	bg:animate(SHDAnimLibrary.animate_resize_linear,time_left,0,nil)
	managers.network:session():send_to_peers("sync_ability_hud", managers.game_play_central:get_heist_timer() + time_left, time_total)
end

function SHDHUDPlayer:set_ability_radial(data)
	-- set ability meter static progress?
	local throwables = self._loadout_equipment_panel:child("throwables")
	local bg = throwables:child("bg")
	bg:set_visible(data.current > 0)
	bg:set_w(throwables:w() * data.current/data.total)
end

function SHDHUDPlayer:set_custom_radial(data)
	-- ????
end


-- returns a fresh table with a copy of all of this panel's data,
-- without saving any references that would impede garbage collection
function SHDHUDPlayer:save()
	local out_data = SHDHUDPlayer.super.save(self)
	
	
	
	return out_data
end

-- setup the visual hud elements with the provided data
function SHDHUDPlayer:load(in_data)
	self.data = in_data
	
	if in_data.health_total == 0 then
		self._health_panel:child("frame"):hide()
	end
	self:_set_health(DISPLAY_MUL * in_data.health_current,DISPLAY_MUL * in_data.health_total,in_data.revives_current)
	self:set_revives_amount(in_data.revives_current)
	
	local DISPLAY_MUL = tweak_data.gui.stats_present_multiplier
	if in_data.armor_total == 0 then
		self._armor_panel:child("frame"):hide()
	end
	
	self:_set_armor(DISPLAY_MUL * in_data.armor_current,DISPLAY_MUL * in_data.armor_total)
	
	if in_data.is_health_bar_unfolded then
		self:unfold_health_bar()
	else
		self:fold_health_bar()
	end
	
	if in_data.is_armor_bar_unfolded then
		self:unfold_armor_bar()
	else
		self:fold_armor_bar()
	end
	
end




return SHDHUDPlayer
