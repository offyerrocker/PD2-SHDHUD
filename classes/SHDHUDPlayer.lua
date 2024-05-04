local SHDHUDTeammate = SHDHUDCore:require("classes/SHDHUDTeammate")
local SHDAnimLibrary = SHDHUDCore:require("classes/SHDHUDAnimations")
local SHDHUDPlayer = class(SHDHUDTeammate)

local DEBUG_VISIBLE = false


function SHDHUDPlayer.create_backpack_label(parent,name)

	if alive(parent:child(name)) then
		parent:remove(parent:child(name))
	end
	
	local w = parent:w()
	local h = 24 -- 15 --parent:h() / 3
	local panel = parent:panel({
		name = name,
		w = w,
		h = h,
		valign = "grow",
		halign = "grow"
	})
	
	local label = panel:text({
		name = "label",
		color = Color.white,
		text = "00",
		font = "fonts/borda_semibold",
		font_size = 20,
		kern = -20,
		monospace = true,
		align = "center",
		vertical = "center",
		layer = 2
	})
	
	local fg = panel:rect({
		name = "fg",
		color = Color("ff8000"),
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
		color = Color("ff8000"),
		alpha = 0.5,
		layer = 0,
		visible = false
	})
	
	local icon, texture_rect = tweak_data.hud_icons:get_icon_data("equipment_doctor_bag")
	local icon = panel:bitmap({
		name = "icon",
		texture = icon,
		texture_rect = texture_rect,
		color = Color.white,
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
		color = Color.white,
		text = "00",
		font = "fonts/borda_semibold",
		font_size = 18, --12
		x = icon:right() + 1,
		y = 0, --1
		kern = -20,
		monospace = true,
		align = "left",
		vertical = "center", --"top"
		layer = 2
	})
	local amount_2 = panel:text({
		name = "amount_2",
		color = Color.white,
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
		color = Color("ff8000"),
		alpha = 0.5,
		layer = 0,
		visible = false
	})
	
	local icon, texture_rect = tweak_data.hud_icons:get_icon_data("equipment_frag")
	local icon = panel:bitmap({
		name = "icon",
		texture = icon,
		texture_rect = texture_rect,
		color = Color.white,
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
		color = Color.white,
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

function SHDHUDPlayer:init(master_panel)
	
	self.config = {
		use_armor_segments = true,
		armor_segment_amount = 20, -- how much armor is in one segment
		armor_segment_group_size = 5, -- how many armor segments are in one group (20 * 5 = 100 ap in one segment group)
		armor_segment_margin_small = 0.25,
		armor_segment_margin_large = 0.5,
		armor_segments_total = 5,
		armor_low_threshold = 0.25, -- below 25% will be considered "low health"
		low_armor_anim = nil, -- will hold the coroutine for alpha flashing health hud anim
		use_health_segments = false,
		health_segment_amount = 20,
		health_segment_group_size = 5,
		health_segment_margin_small = 0.25,
		health_segment_margin_large = 0.5,
		health_segments_total = 5,
		health_low_threshold = 0, -- effectively disabled low health flashing warnings
		low_health_anim = nil -- will hold the coroutine for alpha flashing health hud anim
	}
	
	self.data = {
		health_current = 0,
		health_total = 0,
		armor_current = 0,
		armor_total = 0,
		low_health_anims = {},
		armor_segment_remainder_w = 4,
		armor_segment_w = 9,
		health_segment_w = 9
	}
	
	local player_panel = master_panel:panel({
		name = "player_panel",
		layer = 1,
		w = 256,
		h = 100,
		x = 640,
		y = 500
	})
	self._panel = player_panel
	
	self:create_hud()
end

function SHDHUDPlayer:create_hud()
	local player_panel = self._panel
	
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
	local player_panel = self._panel
	
	local vitals = player_panel:panel({
		name = "vitals",
		w = 154,
		h = 20
	})
	local vitals_debug = vitals:rect({
		name = "vitals_debug",
		color = Color.red,
		visible = DEBUG_VISIBLE,
		alpha = 0.2,
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
	local armor_panel = vitals:panel({
		name = "armor_panel",
		w = vitals:w(),
		h = 8,
		halign = "grow",
		valign = "grow"
	})
	self._armor_panel = armor_panel
	
	--self:create_armor_bar(armor_panel,100)
	
	--[[
	
	local armor_debug = armor_panel:rect({
		name = "armor_debug",
		color = Color.red,
		visible = DEBUG_VISIBLE,
		alpha = 0.5,
		valign = "grow",
		halign = "grow"
	})
	--]]
	
	local health_panel = vitals:panel({
		name = "health_panel",
		w = 154,
		h = 8,
		y = armor_panel:bottom(),
		halign = "grow",
		valign = "grow"
	})
	self._health_panel = health_panel
	
	--self:create_health_bar(health_panel,100)
	
	--[[
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
		color = Color.white,
		w = 2,
		h = 5,
		x = 150,
		y = 1,
		layer = 5
	})
	local health_cradle = health_panel:polyline({
		name = "health_cradle",
		color = Color("cccccc"),
		x = 2,
		y = 4,
		points = {
			Vector3(0,0,0),
			Vector3(0,3,0),
			Vector3(150,3,0),
			Vector3(150,0,0)
		},
		line_width = 1.1,
		closed = false,
		layer = 4
	})
	
	return vitals
end

function SHDHUDPlayer:create_armor_bar(panel,max_amount)
	local h_margin = 2
	local v_margin = 2
	
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
	local frame_fg = frame:rect({
		name = "frame_fg",
		color = Color.black,
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
		--[[
		armor_segment_amount = 20, -- how much armor is in one segment
		armor_segment_group_size = 5, -- how many armor segments are in one group (20 * 5 = 100 ap in one segment group)
		use_health_segments = false,
		health_segment_amount = 20,
		health_segment_group_size = 5
		--]]
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
				color = Color.white,
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
			local segment_bg = frame:rect({
				name = string.format("segment_%i_bg",i),
				color = Color.black,
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
			color = Color.white,
			x = 0,
			y = 0,
			w = max_w,
			h = max_h,
			halign = "grow",
			valign = "grow",
			layer = 2,
			alpha = 1
		})
		local segment_bg = frame:rect({
			name = "segment_1_bg",
			color = Color.black,
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
	return frame
end

function SHDHUDPlayer:create_health_bar(panel,max_amount)
	local h_margin = 2
	local v_margin = 2
	
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
	
	local frame_fg = frame:rect({
		name = "frame_fg",
		color = Color.black,
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
				color = Color.white,
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
			local segment_bg = frame:rect({
				name = string.format("segment_%i_bg",i),
				color = Color.black,
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
			color = Color("ff8000"),
			x = 0,
			y = 0,
			w = max_w,
			h = max_h,
			halign = "grow",
			valign = "grow",
			layer = 2,
			alpha = 1
		})
		local segment_bg = frame:rect({
			name = "segment_1_bg",
			color = Color.black,
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
	return frame
end

function SHDHUDPlayer:create_weapons()
	local player_panel = self._panel
	local vitals = self._vitals_panel
	
	local weapons = player_panel:panel({
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
			0,Color.white:with_alpha(0),
			1,Color.white:with_alpha(0.5)
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
			0,Color.white:with_alpha(0.5),
			1,Color.white:with_alpha(0)
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
		color = Color("ff8000"),
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
			0,Color.white:with_alpha(0),
			1,Color.white:with_alpha(0.5)
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
		color = Color.white,
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
	--local backpack_weapon_label_3 = self.create_backpack_label(backpack_weapons_panel,"backpack_weapon_label_3")
	--backpack_weapon_label_3:set_y(backpack_weapon_label_2:bottom())
	return weapons
end

function SHDHUDPlayer:create_deployables()
	local player_panel = self._panel
	local weapons = self._weapons_panel
	
	local deployables_panel = player_panel:panel({
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
			0,Color.white:with_alpha(0),
			1,Color.white:with_alpha(0.5)
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
			0,Color.white:with_alpha(0.5),
			1,Color.white:with_alpha(0)
		},
		layer = 3,
		halign = "grow",
		valign = "bottom"
	})
	self.add_blur_bg(deployables_panel)
	
	local deployable_1 = SHDHUDPlayer.create_deployable_box(deployables_panel,"deployable_1")
	local deployable_2 = SHDHUDPlayer.create_deployable_box(deployables_panel,"deployable_2")
	deployable_2:set_x(deployable_1:right())
	return deployables_panel
end

function SHDHUDPlayer:create_loadout_equipment()
	local player_panel = self._panel
	local deployables_panel = self._deployables_panel
	
	local loadout_equipment_panel = player_panel:panel({
		name = "loadout_equipment_panel",
		w = 78,
		h = 22,
		x = deployables_panel:x(),
		y = deployables_panel:bottom() + 2
	})
	local loadout_equipment_panel_rect = loadout_equipment_panel:rect({
		name = "loadout_equipment_panel_rect",
		color = Color.white,
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
			0,Color.white:with_alpha(0),
			1,Color.white:with_alpha(0.5)
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
			0,Color.white:with_alpha(0.5),
			1,Color.white:with_alpha(0)
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

	local player_panel = self._panel
	local weapons = self._weapons_panel
	
	local buffs_panel = player_panel:panel({
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

-- slot is ignored since there is currently only one mag readout
-- but i'll keep my options open
function SHDHUDPlayer:set_magazine_amount(slot,current,total)
	local weapons = self._weapons_panel
	local equipped_weapon_panel = weapons:child("equipped_weapon_panel")
	local mag_label = equipped_weapon_panel:child("mag_label")
	local NUM_DIGITS = 2
	
	local primary_color
	local full_color = Color.white
	local partial_color = Color("aaaaaa")
	local empty_color = Color("777777")
	if total > 1 then
		if current < 1 then
			-- empty
			primary_color = partial_color
		else
			primary_color = full_color
			-- not empty
		--elseif total / current < 3 then
			-- low ammo (less than 33%)
		end
	else
		if current == 0 then
			primary_color = partial_color
		else
			primary_color = full_color
		end
	end
	
	self.set_number_label(mag_label,current,NUM_DIGITS,{primary_color,empty_color})
end


function SHDHUDPlayer:set_reserve_amount(slot,current,total)
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

-- returns a fresh table with a copy of all of this panel's data,
-- without saving any references that would impede garbage collection
function SHDHUDPlayer:save()
	local data = table.deep_map_copy(self.data)
	
	return data
end

-- setup the visual hud elements with the provided data
function SHDHUDPlayer:load(data)
	
	self:_set_armor(data.armor_current,data.armor_total)
end




return SHDHUDPlayer