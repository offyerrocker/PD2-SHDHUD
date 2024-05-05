local SHDHUDCriminalBase = SHDHUDCore:require("classes/SHDHUDCriminalBase")
local SHDHUDTeammate = class(SHDHUDCriminalBase)

function SHDHUDTeammate:init(master_panel,index,...)
	SHDHUDTeammate.super.init(self,master_panel,index,...)
	
	local hud_panel = master_panel:panel({
		name = "hud_panel",
		layer = 1,
		w = 256,
		h = 100,
		x = 640,
		y = 500
	})
	self._panel = hud_panel
	
	
end






return SHDHUDTeammate