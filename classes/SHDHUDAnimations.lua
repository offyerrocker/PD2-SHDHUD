local anim = {}

function anim.animate_flash_alpha(o,duration,frequency,min,max)
	duration = duration or math.huge
	local t = 0
	local dt = 0
	min = min or 0
	max = max or 1
	frequency = frequency or 1
	local delta = max - min
	while t < duration do 
		o:set_alpha(min + (0.5 * (1 - math.cos(t * 360 * frequency)) * delta))
		
		dt = coroutine.yield()
		t = t + dt
	end
end

function anim.animate_gradient_recharge(o,o2,duration,frequency,color_1,color_2)
	local t = 0
	local dt = 0
	duration = duration or 1
	frequency = frequency or 0.5
	color_1 = color_1 or Color("5c5c5c") -- main color
	color_2 = color_2 or Color("ffffff") -- pulse color
	local color_delta = color_2 - color_1
	local color_transparent = color_1:with_alpha(0)
	while t < duration do 
		dt = coroutine.yield()
		t = t + dt
		local t_rad = 180 * t
		local pulse_t = (1 - math.cos(t_rad / frequency)) / 2
		local color_lerp = color_1 + (color_delta * pulse_t)
		local lerp_mid
		local lerp_total = t / duration
		if math.sin(t_rad) / frequency <= 0 then
			lerp_mid = lerp_total
		else
			lerp_mid = lerp_total * pulse_t
		end
		o:set_gradient_points({
			0,
			color_1,
			
			lerp_mid,
			color_lerp,
			
			lerp_total,
			color_1,
			
			lerp_total+0.01,
			color_transparent,
			
			1,
			color_transparent
		})
		o2:set_x(lerp_total * o:w())
		
	end
	
	
end

function anim.animate_resize_sq(o,duration,to_w,to_h)
	local from_w,from_h = o:size()
	local delta_w = to_w and from_w and (to_w - from_w)
	local delta_h = to_h and from_h and (to_h - from_h)
	local t,dt = 0,0
	
	while t < duration do 
		local dt = coroutine.yield()
		t = t + dt
		local interp = math.pow(t/duration,2)
		
		if delta_h and delta_w then
			o:set_size(from_w + (delta_w * interp),from_h + (delta_h * interp))
		elseif delta_w then
			o:set_w(from_w + (delta_w * interp))
		elseif delta_h then
			o:set_h(from_h + (delta_h * interp))
		end
	end
	
	if to_w and to_h then
		o:set_size(to_w,to_h)
	elseif to_w then
		o:set_w(to_w)
	elseif to_h then
		o:set_h(to_h)
	end
end

function anim.animate_move_sq(o,duration,to_x,to_y)
	local from_w,from_h = o:size()
	local delta_x = to_x and from_x and (to_x - from_x)
	local delta_y = to_y and from_y and (to_y - from_y)
	local t,dt = 0,0
	
	while t < duration do 
		local dt = coroutine.yield()
		t = t + dt
		local interp = math.pow(t/duration,2)
		
		if delta_y and delta_x then
			o:set_size(from_w + (delta_x * interp),from_h + (delta_y * interp))
		elseif delta_x then
			o:set_w(from_w + (delta_x * interp))
		elseif delta_y then
			o:set_h(from_h + (delta_y * interp))
		end
	end
	
	if to_x and to_y then
		o:set_size(to_x,to_y)
	elseif to_x then
		o:set_w(to_x)
	elseif to_y then
		o:set_h(to_y)
	end
end

return anim