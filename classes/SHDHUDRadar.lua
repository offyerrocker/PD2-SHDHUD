local SHDHUDPanel = SHDHUDCore:require("classes/SHDHUDPanel")
local SHDAnimLibrary = SHDHUDCore:require("classes/SHDHUDAnimations")
local SHDHUDRadar = class(SHDHUDPanel)

function SHDHUDRadar:init(parent)
	local compass_color = Color(1,1,1)
	local radar_hostile_color = Color("ff5d64")
	local radar_hostile_alpha = 0.5
	local compass_alpha = 0.5
	
	-- size in pixels
	self._radar_radius = 144 / 2
	
	
	local panel = parent:panel({
		name = "radar",
		x = 24,
		y = 0,
		w = 240,
		h = 240
	})
	self._panel = panel
	local radar_debug = panel:rect({
		name = "radar_debug",
		valign = "grow",
		halign = "grow",
		color = Color.red,
		alpha = 0.25,
		visible = false,
		layer = 1
	})
	
	local c_x,c_y = panel:center()
	
	local bg = panel:bitmap({
		name = "bg",
		texture = "guis/textures/shdhud/radar_bg",
		valign = "grow",
		halign = "grow",
		alpha = 0.25,
		layer = 1
	})
	self._bg = bg
	bg:set_center(c_x,c_y)
	
	local blur = panel:bitmap({
		name = "blur",
		texture = "guis/textures/shdhud/radar_blur",
		render_template = "VertexColorTexturedBlur3D",
		valign = "grow",
		halign = "grow",
		layer = 0
	})
	self._blur = blur
	blur:set_center(c_x,c_y)
	
	local north_arrow = panel:bitmap({
		name = "north_arrow",
		texture = "guis/textures/shdhud/radar_atlas",
		texture_rect = {
			1*16,0*16,
			16,16
		},
		color = compass_color,
		alpha = compass_alpha,
		layer = 5
	})
	self._north_arrow = north_arrow
	
	local north_label = panel:text({
		name = "north_label",
		text = "N",
		font = "fonts/borda_semibold",
		font_size = 20,
		w = 20,
		h = 20,
		align = "center",
		vertical = "top",
		valign = "grow",
		halign = "grow",
		color = Color(1,1,1),
		layer = 2
	})
	self._north_label = north_label
	
	local origin_circle = panel:bitmap({
		name = "origin_circle",
		texture = "guis/textures/shdhud/radar_atlas",
		texture_rect = {
			1*16,1*16,
			16,16
		},
		color = compass_color,
		alpha = 1,
		layer = 5
	})
	self._origin_circle = origin_circle
	origin_circle:set_center(c_x,c_y)
	
	local vision_cone = panel:bitmap({
		name = "vision_cone",
		texture = "guis/textures/shdhud/radar_vision_cone",
		render_template = "VertexColorTexturedRadial",
		valign = "grow",
		halign = "grow",
		color = Color(0,1,0),
		alpha = 0.25,
		layer = 2
	})
	self._vision_cone = vision_cone
	vision_cone:set_center(c_x,c_y)
	
	local range_label = panel:text({
		name = "range_label",
		text = "ø90m", -- alt Ø
		font = "fonts/borda_semibold",
		font_size = 20,
		w = 40,
		h = 20,
		align = "right",
		vertical = "top",
		valign = "grow",
		halign = "grow",
		color = compass_color,
		layer = 2
	})
	self._range_label = range_label
	local text_distance = self._radar_radius + 64
	range_label:set_position(c_x + text_distance * math.cos(-60-90),c_y + text_distance * math.sin(-60-90))
	
	local range_blur = panel:bitmap({
		name = "range_blur",
		texture = "guis/textures/test_blur_df",
		render_template = "VertexColorTexturedBlur3D",
		--color = Color.red,
		x = range_label:x(),
		y = range_label:y(),
		valign = "grow",
		halign = "grow",
		w = 36,
		h = 20,
		layer = 1
	})
	self._range_blur = range_blur
	
	local angle_label = panel:text({
		name = "north_label",
		text = "0°",
		font = "fonts/borda_semibold",
		font_size = 20,
		w = 40,
		h = 20,
		align = "right",
		vertical = "top",
		valign = "grow",
		halign = "grow",
		color = compass_color,
		layer = 2
	})
	self._angle_label = angle_label
	angle_label:set_position(c_x + (text_distance * math.cos(-75-90)),c_y + (text_distance * math.sin(-75-90)))
	
	local angle_blur = panel:bitmap({
		name = "angle_blur",
		texture = "guis/textures/test_blur_df",
		render_template = "VertexColorTexturedBlur3D",
		--color = Color.blue,
		x = angle_label:x() + 4,
		y = angle_label:y(),
		valign = "grow",
		halign = "grow",
		w = 38,
		h = 20,
		layer = 1
	})
	self._angle_blur = angle_blur
	
	self._radar_segments = {}
	
	local ring_layers = {
		[0] = "guis/textures/shdhud/radar_ring_0",
		"guis/textures/shdhud/radar_ring_1",
		"guis/textures/shdhud/radar_ring_2",
		"guis/textures/shdhud/radar_ring_3",
		"guis/textures/shdhud/radar_ring_4"
	}
	
	self._radar_angles = {
		70, -- north
		42, -- northeast
		42.5, -- east
		38, -- southeast
		45, -- south
		38, -- southwest
		42.5, -- west
		42 -- northwest
	}
	self._radar_distances = {
		250,
		750,
		1500,
		2000
	}
	
	-- intentionally skip point-blank
	for i,ring_texture in ipairs(ring_layers) do 
		self._radar_segments[i] = {}
		local start_angle = -self._radar_angles[1] / 2
		for j,angle in ipairs(self._radar_angles) do 
			local new_segment = panel:bitmap({
				name = string.format("radar_%i_%i",i,j),
				texture = ring_texture,
				render_template = "VertexColorTexturedRadial",
				rotation = start_angle + 1,
				valign = "grow",
				halign = "grow",
				color = Color((angle - 1)/360,1,0),
				alpha = 0,
				visible = true,
				layer = 3
			})
			new_segment:set_center(c_x,c_y)
			start_angle = start_angle + angle
			
			self._radar_segments[i][j] = {
				bitmap = new_segment,
				state = false
			}
		end
	end
	local center_segment = panel:bitmap({
		name = "radar_0_1",
		texture = ring_layers[0],
		rotation = 0,
		valign = "grow",
		halign = "grow",
		color = radar_hostile_color,
		alpha = 0,
		visible = true,
		layer = 3
	})
	center_segment:set_center(c_x,c_y)
	self._radar_segments[0] = { [1] = { bitmap=center_segment, state=false} }
	
	self:set_north_angle(0)
	self:set_vision_cone(70)
	self:set_range_label(self._radar_distances[#self._radar_distances]/100)
end

function SHDHUDRadar:set_north_angle(angle)
	local radius = self._radar_radius
	local text_distance = radius + 16
	local arrow_distance = radius + 4
	
	local c_x,c_y = self._panel:center()
	
	self._north_arrow:set_rotation(angle)
	local _angle = angle - 90
	self._north_arrow:set_center(c_x + arrow_distance * math.cos(_angle),c_y + arrow_distance * math.sin(_angle))
	
	self._north_label:set_center(c_x + text_distance * math.cos(_angle),c_y + text_distance * math.sin(_angle))
	
	self:set_angle_label(angle)
end

function SHDHUDRadar:set_vision_cone(angle)
	self._vision_cone:set_color(Color(angle/360,1,0))
	self._vision_cone:set_rotation(-angle/2)
end

function SHDHUDRadar:set_range_label(range)
	self:_set_range_label(string.format("%im",range))
end

function SHDHUDRadar:_set_range_label(str)
	self._range_label:set_text(str)
	--local x,y,w,h = self._range_label:text_rect()
	--self._range_blur:set_position(x-(w/2)-2,y-2)
	--self._range_blur:set_size(w+2,h+2)
end

function SHDHUDRadar:set_angle_label(angle)
	self:_set_angle_label(string.format("%i°",angle))
end

function SHDHUDRadar:_set_angle_label(str)
	self._angle_label:set_text(str)
	--local x,y,w,h = self._angle_label:text_rect()
	--self._angle_blur:set_position(x-w-2,y-2)
	--self._angle_blur:set_size(w+2,h+2)
end

function SHDHUDRadar:set_radar_segment(distance_tier,angle_tier,enabled)
	if distance_tier == 0 then
		angle_tier = 1
	end
	local segments = self._radar_segments[distance_tier]
	local segment_data = segments and segments[angle_tier]
	if segment_data then
		if segment_data.state ~= enabled then
			segment_data.state = enabled
			local bitmap = segment_data.bitmap
			bitmap:stop()
			local radar_hostile_alpha = 0.5
			if enabled then
				bitmap:animate(SHDAnimLibrary.animate_alpha_sq,(radar_hostile_alpha-bitmap:alpha())/4,radar_hostile_alpha)
			else
				bitmap:animate(SHDAnimLibrary.animate_alpha_sq,bitmap:alpha()/3,0)
			end
		end
	end
end









return SHDHUDRadar