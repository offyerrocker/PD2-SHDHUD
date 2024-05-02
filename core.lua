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
SHDHUDCore._SETTINGS_PATH = SHDHUDCore._SETTINGS_PATH or (SavePath .. "shdhud_settings.json")
SHDHUDCore._LAYOUT_PATH = SHDHUDCore._LAYOUT_PATH or (SavePath .. "shdhud_layout.ini")

SHDHUDCore.DEFAULT_SETTINGS = {
	hi = "yes"
}

SHDHUDCore.settings = table.deep_map_copy(SHDHUDCore.DEFAULT_SETTINGS)


SHDHUDCore.DEFAULT_LAYOUT = {
	
}
SHDHUDCore.SORT_LAYOUT = {

}
SHDHUDCore.layout = table.deep_map_copy(SHDHUDCore.DEFAULT_LAYOUT)


-- Load libraries
SHDHUDCore._classes = {}
do 
	--SHDHUDCore._classes.SHDHUDPanel = blt.vm.dofile(mod_path .. "classes/SHDHUDPanel.lua")
	SHDHUDCore._classes.LIP = blt.vm.dofile(mod_path .. "classes/LIP.lua")
end

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
	local data = SHDHUDCore._classes.LIP.load(SHDHUDCore._LAYOUT_PATH)
	if data then
		self._layout = data.Layout
	end
end

function SHDHUDCore:save_layout()
	local data = {
		Layout = self._layout
	}
	SHDHUDCore._classes.LIP.save(SHDHUDCore._LAYOUT_PATH,SHDHUDCore.SORT_LAYOUT)
end
