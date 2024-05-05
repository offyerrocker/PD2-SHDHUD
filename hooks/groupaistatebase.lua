Hooks:PostHook(GroupAIStateBase,"init","shdhud_groupaistatebase_init",function(self)
	self:add_listener(
		"shdhud_on_police_called",
		{ "enemy_weapons_hot",
			"on_police_called"
		}, --enemy_weapons_hot, on_police_called
		function(...)
			managers.hud:shdhud_on_mission_loud()
		end
	)
	
	-- todo cloaker_spawned hud distortion
end)