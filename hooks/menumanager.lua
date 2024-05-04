if not BeardLib then
	blt.vm.dofile(ModPath .. "core.lua")
end

Hooks:Add("LocalizationManagerPostInit", "SHDHUD_LocalizationManagerPostInit", function(loc)
	if not BeardLib then
		loc:load_localization_file( SHDHUDCore._DEFAULT_LOCALIZATION_PATH )
	end
end)

Hooks:Add("MenuManagerInitialize", "SHDHUD_MenuManagerInitialize", function(menu_manager)
	SHDHUDCore:load_settings()
	SHDHUDCore:load_layout()
	SHDHUDCore:load_colors()
	
--[[
	MenuCallbackHandler.callback_olib_allow_debug_logs = function(self,item) --on keypress
		Olib.settings.logging_enabled = item:value() == "on"
		Olib:Save()
	end
	
	Olib:Load()
	MenuHelper:LoadFromJsonFile(Olib._path .. "options.txt", Olib, Olib.settings)
	--]]
end)
