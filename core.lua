-- require PD2's table library

--[[
	todo
armor/health segmentation




--]]

--[[

TECH SPECS:
	- positions editable in-game only
	- settings editable in-menu or in-game







panels list:

MINIMAP
- Objectives, distance
	Minimap, radial enemy indicator, waypoints

LEVEL (top right)
	- Level amount 
	- XP bar (mod compat)
	- XP amount
	- Infamy amount?

PLAYER PANEL
	- Primary/Secondary ammo counts
	- Deployable amount
	- Throwables amount
	- Zipties amount
	- BUFFS
		- small icons + duration/stacks
		
TEAMMATE HEAD
	- Name
	- Profile picture
	- Armor bar
	- HP bar
	
TEAMMATES PANEL
	- Infamy/level
	- Name
	- Armor
	- Health
		- equipment?

MISC:
	- floating entity health
		- Enemies
			- Faction
		- Friendlies
			- Criminals
			- Deployables
	- Damage numbers

--]]






-- Init mod vars and consts

local mod_path = SHDHUDCore and SHDHUDCore:GetPath() or ModPath
_G.SHDHUDCore = SHDHUDCore or {}

SHDHUDCore._MOD_PATH = mod_path
SHDHUDCore._ASSETS_PATH = SHDHUDCore._ASSETS_PATH or (mod_path .. "assets/")
SHDHUDCore._DEFAULT_LOCALIZATION_PATH = SHDHUDCore._DEFAULT_LOCALIZATION_PATH or (mod_path .. "localization/english.json")
SHDHUDCore._COLORS_PATH = SHDHUDCore._COLORS_PATH or (SavePath .. "shdhud_colors.ini")
SHDHUDCore._SETTINGS_PATH = SHDHUDCore._SETTINGS_PATH or (SavePath .. "shdhud_settings.json")
SHDHUDCore._LAYOUT_PATH = SHDHUDCore._LAYOUT_PATH or (SavePath .. "shdhud_layout.ini")

SHDHUDCore.DEFAULT_COLORS = { -- this table holds string representations of hex color numbers!
	white = "ffffff",
	red = "ff0000",
	green = "00ff00",
	player_hud_ammo_magazine_full = "ffffff", -- non-empty numbers
	player_hud_ammo_magazine_empty_1 = "777777", -- for all but least significant empty digits
	player_hud_ammo_magazine_empty_2 = "aaaaaa", -- for least significant empty digit, if completely empty
	player_hud_ammo_reserve_full = "999999", -- non-empty numbers
	player_hud_ammo_reserve_empty_1 = "777777", -- empty numbers
	player_hud_text_main = "ffffff",
	player_hud_backpack_text = "ffffff",
	player_hud_deployable_text = "ffffff",
	player_hud_deployable_icon = "ffffff",
	player_hud_loadout_text = "ffffff",
	player_hud_loadout_icon = "ffffff",
	player_hud_equipment_text = "ffffff",
	player_hud_equipment_icon = "ffffff",
	player_hud_dividers = "ffffff",
	player_hud_health_hat = "ffffff",
	player_hud_health_cradle = "cccccc",
	player_hud_health_bar_fg = "ff8000",
	player_hud_health_bar_bg = "000000",
	player_hud_armor_bar_fg = "ffffff",
	player_hud_armor_bar_bg = "000000",
	player_hud_highlight = "ff8000" -- signature orange
}
SHDHUDCore._colors = {} -- this table holds Color objects!
for id,color_code in pairs(SHDHUDCore.DEFAULT_COLORS) do 
	SHDHUDCore._colors[id] = Color(color_code)
end

SHDHUDCore.SORT_COLORS = SHDHUDCore.SORT_COLORS or (SavePath .. "shdhud_layout.ini")

SHDHUDCore.DEFAULT_SETTINGS = {
	hi = "yes"
}

SHDHUDCore.settings = table.deep_map_copy(SHDHUDCore.DEFAULT_SETTINGS)


SHDHUDCore.DEFAULT_LAYOUT = {
	
}
SHDHUDCore.SORT_LAYOUT = {

}
SHDHUDCore.layout = table.deep_map_copy(SHDHUDCore.DEFAULT_LAYOUT)

SHDHUDCore._classes = {}

function SHDHUDCore.file_exists(path)
	if not path then
		return false
	end
	if SystemFS and SystemFS.exists then
		return SystemFS:exists(path)
	else
		return file.FileExists(path)
	end
end

function SHDHUDCore.directory_exists(path)
	if not path then
		return false
	end
	if SystemFS and SystemFS.exists then
		return SystemFS:exists(path)
	else
		return FileIO:DirectoryExists(path)
	end
end

function SHDHUDCore:require(resource)
	if not resource then
		error("Required resource is nil (expected string filepath)")
		return
	end
	
	if self._classes[resource] then
		return self._classes[resource]
	else --if exists then dofile and return
		local path = self._MOD_PATH .. resource .. ".lua"
		if not self.file_exists(path) then
			error("File not found at path: " .. tostring(path))
			return
		end
		
		local result,e = blt.vm.dofile(path)
		if result then
			self._classes[resource] = result
			return result
		elseif e then
			error(e)
			return
		else
			error("Invalid resource path: " .. tostring(path))
		end
	end
end

local LIP = SHDHUDCore:require("classes/LIP")


function SHDHUDCore:get_color(id)
	return id and self._colors[id] or Color.white
end

-- I/O

function SHDHUDCore:load_settings()
	local file = io.open(self._SETTINGS_PATH, "r")
	if file then
		for k, v in pairs(json.decode(file:read("*all"))) do
			self.settings[k] = v
		end
	end
end

function SHDHUDCore:save_settings()
	local file = io.open(self._SETTINGS_PATH,"w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

function SHDHUDCore:load_layout()
	if self.file_exists(self._LAYOUT_PATH) then
		local data = LIP.load(self._LAYOUT_PATH)
		if data and data.Layout then
			self.layout = data.Layout
		end
	end
end

function SHDHUDCore:save_layout()
	local data = {
		Layout = self.layout
	}
	LIP.save(self._LAYOUT_PATH,data,self.SORT_LAYOUT)
end

function SHDHUDCore:load_colors()
	if self.file_exists(self._COLORS_PATH) then
		local data = LIP.load(self._COLORS_PATH)
		if data and data.Colors then
			for id,n in pairs(data.Colors) do 
				self._colors[id] = Color(string.format("%06x",n))
			end
		end
	end
end

function SHDHUDCore:save_colors()
	-- get string hex codes from colors,
	-- append "0x" and store/retrieve them as numbers
	local color_tbl = {}
	for id,color in pairs(self._colors) do
		color_tbl[id] = string.format("0x%s",self.color_to_hex(color))
	end
	local data = {
		Colors = color_tbl
	}
	LIP.save(self._COLORS_PATH,data,self.SORT_COLORS)
end

-- note: this discards alpha information
function SHDHUDCore.color_to_hex(color)
	if Color.to_hex then
		return color:to_hex()
	else
		return string.format("%02x%02x%02x",255*color.red,255*color.green,255*color.blue)
	end
end

--[[

-- load custom assets (not used)
function SHDHUDCore:load_fonts()
	local function check_asset_added(path,load_as_ext,actual_ext)
		local ext_ids = Idstring(load_as_ext)
		
		if not (DB and DB:has(ext_ids, path)) then 
			local full_asset_path = SHDHUDCore._ASSETS_PATH .. path .. "." .. actual_ext
			BLT.AssetManager:CreateEntry(Idstring(path),ext_ids,full_asset_path)
		end
	end
	check_asset_added("fonts/borda_demibold","font","font")
	check_asset_added("fonts/borda_demibold","texture","texture")
	check_asset_added("fonts/borda_regular","font","font")
	check_asset_added("fonts/borda_regular","texture","texture")
	check_asset_added("fonts/borda_semibold","font","font")
	check_asset_added("fonts/borda_semibold","texture","texture")
end
--SHDHUDCore:load_fonts()

--]]