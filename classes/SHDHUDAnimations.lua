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

return anim