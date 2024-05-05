local SHDHUDPanel = class()

function SHDHUDPanel:init(parent,params)
--[[
	self._parent = parent
	local panel = parent:get_panel():panel({
		name = params.name
	})
	self._panel = panel
	--]]
end

function SHDHUDPanel:panel()
	return self._panel
end

function SHDHUDPanel:show()
	self._panel:show()
end

function SHDHUDPanel:hide()
	self._panel:hide()
end

function SHDHUDPanel.add_progress_bg(panel)
	local progress_bg = panel:gradient({
		name = "progress_bg",
		w = panel:w(),
		h = panel:h(),
		valign = "grow",
		halign = "grow",
		gradient_points = {
			0,
			Color.white:with_alpha(0),
			1,
			Color.white:with_alpha(0)
		},
		layer = 1,
		visible = false
	})
	
	local progress_bobber = panel:rect({
		name = "progress_bobber",
		w = 2,
		h = panel:h(),
		x = 0,
		y = 0,
		valign = "grow",
		halign = "scale",
		color = Color.white,
		layer = 6,
		visible = false
	})
	return progress_bg,progress_bobber
end

function SHDHUDPanel.add_blur_bg(panel)
	local w,h = panel:size()
	local blur = panel:bitmap({
		name = "auto_blur",
		color = Color(1,1,1),
		texture = "guis/textures/test_blur_df",
		render_template = "VertexColorTexturedBlur3D",
		valign = "grow",
		halign = "grow",
		w = w,
		h = h,
		layer = -3
	})
	
	local bg = panel:rect({
		name = "auto_bg",
		color = Color(0,0,0),
		alpha = 0.1,
		valign = "grow",
		halign = "grow",
		w = w,
		h = h,
		layer = -2
	})
	
	return blur,bg
end

function SHDHUDPanel.set_number_label(textgui,amount,num_digits,custom_colors)
	num_digits = num_digits or 2
	local current_display = math.min(amount,math.pow(10,num_digits)-1)
	local str = string.format("%0" .. tostring(num_digits) .. "i",current_display)
	local str_len = string.len(str)
	
	textgui:clear_range_color()
	textgui:set_text(str)
	
	local full_color = custom_colors and custom_colors[1] or Color.white
	local empty_color = custom_colors and custom_colors[2] or Color("777777")
	local partial_color = custom_colors and custom_colors[3]
	
	local main_color,range_end
	if amount > 0 then
		range_end = num_digits - (1 + math.floor(0.01 + math.log(amount,10))) -- i love floating point precision errors
		main_color = full_color
	else
		if partial_color then
			range_end = num_digits - 1
			main_color = partial_color
		else
			range_end = num_digits
			main_color = empty_color
		end
	end
	--Print("amount",amount,"range_end",range_end)
	if range_end == num_digits then
		textgui:set_range_color(0,range_end,main_color)
	else
		textgui:set_range_color(0,range_end,empty_color)
		textgui:set_range_color(range_end,str_len,main_color)
	end
	
end

-- returns a fresh table with a copy of all of this panel's data,
-- without saving any references that would impede garbage collection
function SHDHUDPanel:save()
	local out_data = {}
	
	return out_data
end

-- setup the visual hud elements with the provided data
function SHDHUDPanel:load(data)
	
end




return SHDHUDPanel
