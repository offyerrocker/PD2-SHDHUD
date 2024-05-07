local SHDHUDPanel = SHDHUDCore:require("classes/SHDHUDPanel")
local SHDAnimLibrary = SHDHUDCore:require("classes/SHDHUDAnimations")
local SHDHUDObjectives = class(SHDHUDPanel)


function SHDHUDObjectives:init(parent,...)
	SHDHUDObjectives.super.init(self,parent,...)
	
	local panel = parent:panel({
		name = "radar",
		x = 0,
		y = 96,
		w = 240,
		h = 64
	})
	self._panel = panel
	
	local debug_panel = panel:rect({
		name = "debug_panel",
		valign = "grow",
		halign = "grow",
		color = Color.red,
		alpha = 0.25,
		visible = false,
		layer = 1
	})
	
	
	self._active_objective_id = nil
	self._amount_current = nil
	self._amount_total = nil
	self._objective_text = nil
	
end

function SHDHUDObjectives:activate_objective(data)
	local text_color = Color(1,1,1)
	self._active_objective_id = data.id
	
	local obj_panel = self._panel:panel({
		name = data.id,
		valign = "grow",
		halign = "grow"
	})
	local debug_obj = obj_panel:rect({
		name = "debug_obj",
		color = Color.blue,
		valign = "grow",
		halign = "grow",
		visible = false,
		layer = 0,
		alpha = 0.2
	})
	
	local objective_label = obj_panel:text({
		name = "objective_label",
		text = data.text,
		font = "fonts/borda_semibold",
		font_size = 20,
		align = "left",
		vertical = "top",
		valign = "grow",
		halign = "grow",
		color = text_color,
		layer = 2
	})
	
	local label_blur = obj_panel:bitmap({
		name = "label_blur",
		texture = "guis/textures/test_blur_df",
		render_template = "VertexColorTexturedBlur3D",
		valign = "grow",
		halign = "grow",
		w = 64,
		h = 64,
		visible = true,
		layer = 0
	})
	local _,_,w,h = objective_label:text_rect()
	label_blur:set_position(objective_label:x()-2,objective_label:y()-2)
	label_blur:set_size(w+2,h+2)
	
	local objective_amount = obj_panel:text({
		name = "objective_amount",
		text = "",
		font = "fonts/borda_semibold",
		font_size = 20,
		x = 24,
		y = 24,
		align = "left",
		vertical = "top",
		valign = "grow",
		halign = "grow",
		color = text_color,
		visible = true,
		layer = 2
	})
	
	local amount_blur = obj_panel:bitmap({
		name = "amount_blur",
		texture = "guis/textures/test_blur_df",
		render_template = "VertexColorTexturedBlur3D",
		valign = "grow",
		halign = "grow",
		w = 0,
		h = 64,
		visible = true,
		alpha = 1,
		layer = 0
	})
	
	if data.amount then
		self:update_amount_objective(data)
	end
	self._objective_text = data.text
	
end

function SHDHUDObjectives:remind_objective(id)
	if id == self._active_objective_id then
		local obj_panel = self._panel:child(id)
		
		-- animate remind
		
	end
end

function SHDHUDObjectives:complete_objective(data)
	if data.id == self._active_objective_id then
		-- remove objective
		local obj_panel = self._panel:child(data.id)
		if obj_panel then
			obj_panel:stop()
			-- animate removal
			self._panel:remove(obj_panel)
		end
		
		self._active_objective_id = nil
		self._amount_current = nil
		self._amount_total = nil
		self._objective_text = nil
	end
end

function SHDHUDObjectives:update_amount_objective(data)
	if data.id == self._active_objective_id then
		local current_amount = data.current_amount or 0
		local amount = data.amount
		local obj_panel = self._panel:child(data.id)
		if alive(obj_panel) then
			local objective_amount = obj_panel:child("objective_amount")
			objective_amount:set_text(string.format("%s/%s",current_amount,amount))
			local amount_blur = obj_panel:child("amount_blur")
			local _,_,w,h = objective_amount:text_rect()
			
			amount_blur:set_position(objective_amount:x()-2,objective_amount:y()-2)
			amount_blur:set_size(w+2,h+2)
		end
		self._amount_current = current_amount
		self._amount_total = amount
	end
end

function SHDHUDObjectives:_set_objective_text(data)
	local obj_panel = self._panel:child(data.id)
	if alive(obj_panel) then
		local objective_label = obj_panel:child("objective_label")
		objective_label:set_text(data.text)
		local label_blur = obj_panel:child("label_blur")
		local x,y,w,h = objective_label:text_rect()
		
		label_blur:set_position(x-(w/2)-2,y-2)
		label_blur:set_size(w+2,h+2)
	end
end

function SHDHUDObjectives:save()
	local out_data = {}
	
	out_data.id = self._active_objective_id
	out_data.current_amount = self._amount_current
	out_data.amount = self._amount_total
	out_data.text = self._objective_text
	
	return out_data
end

function SHDHUDObjectives:load(in_data)
	self._active_objective_id = in_data.id
	self._amount_current = in_data.current_amount
	self._amount_total = in_data.amount
	self._objective_text = in_data.text
	if in_data.amount then
		self:activate_objective(in_data)
		self:update_amount_objective(in_data)
	end
end


return SHDHUDObjectives