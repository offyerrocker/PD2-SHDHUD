local hooked_class,hook_prefix
if string.lower(RequiredScript) == "lib/units/weapons/raycastweaponbase" then
	hooked_class = RaycastWeaponBase
	hook_prefix = "raycastweaponbase_"
elseif string.lower(RequiredScript) == "lib/units/weapons/newraycastweaponbase" then
	hooked_class = NewRaycastWeaponBase
	hook_prefix = "newraycastweaponbase_"
end

Hooks:PostHook(hooked_class,"underbarrel_toggle",hook_prefix .. "underbarrel_toggle",function(self)
	local is_on = Hooks:GetReturn()
	
end)