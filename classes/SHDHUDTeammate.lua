


local SHDHUDPanel = SHDHUDCore:require("classes/SHDHUDPanel")
local SHDHUDTeammate = class(SHDHUDPanel)

function SHDHUDTeammate:init()
	
end










-- returns a fresh table with a copy of all of this panel's data,
-- without saving any references that would impede garbage collection
function SHDHUDTeammate:save()
	local data = {}
	
	return data
end

-- setup the visual hud elements with the provided data
function SHDHUDTeammate:load(data)
	
end




return SHDHUDTeammate
