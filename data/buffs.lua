local buffs = {
	["vip"] = { -- captain winters; only applied to enemies
		priority = 1,
		icon_type = "texture",
		icon_id = "guis/textures/ability_circle_fill", --!
		icon_rect = nil,
		name_id = "buff_vip_name"
	},
	["ecm_basic"] = { --not implemented
		priority = 0,
		icon_type = "skill",
		icon_id = "ecm_2x",
		icon_rect = {3,4},
		name_id = "buff_ecm_weak_name",
		duration = 20 -- tweak_data.upgrades.ecm_jammer_base_battery_life
	},
	["ecm_strong"] = { --not implemented
		icon_type = "skill",
		priority = 0,
		icon_id = "ecm_booster",
		icon_rect = {6,3},
		name_id = "buff_ecm_strong_name",
		duration = 30 --(tweak_data.upgrades.ecm_jammer_base_battery_life * 1.5)
	},
	["ecm_feedback"] = { --not implemented
		icon_type = "skill",
		priority = 0,
		icon_id = "ecm_feedback",
		icon_rect = {1,2},
		name_id = "buff_ecm_feedback_name",
		duration = 15 --tweak_data.upgrades.ecm_feedback_min_duration
	},
	--[[
	["dmg_resist_total"] = { --aggregated
		icon_type = "skill",
		priority = 1,
		icon_id = "juggernaut", --naut too sure about this icon. --drop_soap?
		name_id = "noblehud_buff_dmg_aggregated_label",
		value_type = "value",
		label_compact = "$VALUE%",
		flash = false
	},
	["crit_chance_total"] = { --aggregated
		icon_type = "skill",
		priority = 1,
		icon_id = "backstab",
		name_id = "noblehud_buff_crit_aggregated_label",
		label_compact = "$VALUE%",
		value_type = "value",
		flash = false
	},
	["dodge_chance_total"] = { --aggregated
		icon_type = "skill",
		priority = 1,
		icon_id = "jail_diet", --'dance_instructor' is pistol mag bonus
		name_id = "noblehud_buff_dodge_aggregated_label",
		label_compact = "$VALUE%",
		value_type = "value",
		flash = false
	},
	["hp_regen"] = { --aggregated, standard timed-healing from multiple sources (muscle, hostage taker, etc)
		icon_type = "perk",
		priority = 1,
		icon_id = 17, --chico perk deck
		icon_tier = 3, --heart with hollow +  
		persistent_timer = true,
		name_id = "noblehud_buff_regen_aggregated_label",
		label_compact = "x$VALUE $TIMER",
		duration = 10,
		value_type = "timer",
		text_color = Color("FFD700"),
		flash = false
	},
	--]]
	["long_dis_revive"] = {
		icon_type = "skill",
		priority = 3,
		icon_id = "inspire",
		icon_rect = {4,9},
		color_type = "cooldown",
		duration = 20,
		name_id = "buff_long_dis_revive_name"
	},
	["morale_boost"] = {
		icon_type = "skill",
		priority = 3,
		icon_id = "inspire",
		icon_rect = {4,9},
		duration = 4,
		name_id = "buff_morale_boost_name"
	},
	--[[
	["fully_loaded"] = { --throwable pickup chance; not implemented
		disabled = true,
		priority = 2
	},
	["dire_need"] = { --todo
		icon_type = "skill",
		priority = 1,
		icon_id = "drop_soap",
		name_id = "noblehud_buff_dire_need",
		label_compact = "$TIMER",
		duration = 10,
		value_type = "timer",
		flash = true
	},
	["hitman"] = {
		icon_type = "perk",
		priority = 5,
		icon_id = 4, --hitman perk deck
		icon_tier = 7,
--		disabled = true, --guaranteed regen from Hitman 9 Tooth and Claw; not implemented
		name_id = "noblehud_buff_hitman_label",
		label_compact = "$TIMER",
		persistent_timer = true,
		duration = 1.5,
		value_type = "timer",
		text_color = NobleHUD.color_data.hud_buff_status,
		flash = false
	},
	--]]
	["overdog"] = {
		icon_type = "perk",  --10x melee damage within 1 second, from infiltrator 1 or Sociopath 1, Overdog; not implemented
		priority = 4,
		icon_id = 9,
		icon_tier = 1,
		name_id = "buff_overdog_name",
		duration = 1,
		flash = true
	},
	["tension"] = { 
		disabled = true,  --sociopath armorgate on kill cooldown; 3; also blending in so idk
		icon_type = "perk",
		priority = 7,
		duration = 1,
		icon_id = 9,
		icon_tier = 3,
		name_id = "buff_tension_name",
		color_type = "cooldown"
	},
	["clean_hit"] = { 
		disabled = true,  --sociopath health regen on melee kill cooldown; 5/9; also blending in so idk
		icon_type = "perk",
		priority = 7,
		duration = 1,
		icon_id = 9,
		icon_tier = 3,
		name_id = "noblehud_buff_clean_hit",
		color_type = "cooldown"
	},
	["overdose"] = {
		disabled = true, --sociopath armorgate on medium range kill cooldown; 7/9; also blending in so idk
		icon_type = "perk",
		priority = 7,
		duration = 1,
		icon_id = 9,
		icon_tier = 3,
		name_id = "buff_overdose_name",
		color_type = "cooldown"
	},
	["melee_life_leech"] = {
		icon_type = "perk", --melee hit regens 20% hp, once per 10s from infiltrator 9/9 Life Drain; not implemented
		priority = 3,
		duration = 10,
		icon_id = 8,
		icon_tier = 9,
		name_id = "buff_life_drain_name",
		color_type = "cooldown"
	},
	["loose_ammo_restore_health"] = { --gambler medical supplies; n health on ammo pickup, once per 3s from Gambler 1/9 Medical Supplies
		icon_type = "perk",
		priority = 5,
		duration = 3,
		icon_id = 10,
		icon_tier = 1,
		tier_floors = {1,7,9},
		name_id = "buff_medical_supplies_name",
		color_type = "cooldown"
	},
	["loose_ammo_give_team"] = { --gambler ammo give out; half normal ammo pickup to all team members once every 5 seconds from Gambler 3
		icon_type = "perk",
		priority = 63,
		duration = 5,
		icon_id = 10,
		icon_tier = 3,
		icon_rect = {3,5},
		name_id = "buff_ammo_give_out_name",
		color_type = "cooldown"
	},
	["grinder"] = {
		icon_type = "perk",
		priority = 2,
		icon_id = 11,
		icon_tier = 1, --overridden by tier_floors
		tier_floors = {1,3,5,7,9},
		icon_rect = {6,1},
		name_id = "buff_grinder_name"
	},
	--[[
	["yakuza"] = { 
		icon_type = "perk", --armor recovery rate, like berserker
		priority = 2,
		icon_id = 12,
		icon_tier = 3,
		name_id = "noblehud_buff_yakuza_label"
	},
	--]]
	["stored_health"] = {
		icon_type = "perk",--stored health
		priority = 2,
		disabled = false,
		icon_id = 13, --ex-president perk deck
		icon_tier = 1,
		name_id = "buff_stored_health_name"
	},
	["hysteria"] = {
		icon_type = "perk", -- hysteria from maniac perk deck
		priority = 2,
		icon_id = 14,
		icon_rect = {1,7},
		tier_floors = {1,9},
		icon_tier = 1,
		name_id = "buff_hysteria_name"
	},
	["anarchist_armor_regen"] = {
		icon_type = "perk",
		priority = 1,
		icon_id = 15,
		icon_tier = 1,
		name_id = "buff_anarchist_name",
		persistent_timer = true
	},
	["anarchist_lust_for_life"] = {
		disabled = true,
		icon_type = "perk",
		priority = 4,
		icon_id = 15,
		icon_tier = 9,
		duration = 1.5,
		name_id = "buff_lust_for_life_name"
	},
	["armor_break_invulnerable"] = {
		icon_type = "perk", --red for 15s cooldown; blue for 2s invuln period
		priority = 3,
		icon_id = 15,
		icon_tier = 1,
		name_id = "buff_armor_break_invulnerable_name"
	},
	["wild_kill_counter"] = { -- biker kills
		icon_type = "perk",
		priority = 1,
		icon_id = 16,
		icon_tier = 1,
		name_id = "buff_wild_kill_counter_name",
		color_type = "neutral",
		persistent_timer = true
	},
	["chico_injector"] = {
		icon_type = "perk",
		priority = 3,
		icon_id = 17,--"chico_injector",
		icon_tier = 1,
		name_id = "buff_kingpin_injector_name"
	},
	["sicario"] = {
		icon_type = "perk",
		priority = 3,
		icon_id = 18,
		tier_floors = {1,9},
		icon_tier = 1,
		name_id = "buff_sicario_name"
	},
	["delayed_damage"] = {
		icon_type = "perk",
		priority = 3,
		icon_id = 19,
		tier_floors = {1,9},
		icon_tier = 1,
		name_id = "buff_delayed_damage_name"
	},
	["tag_team"] = {
		icon_type = "perk", --is being tagged; tag team duration
		priority = 3,
		icon_id = 20,
		icon_tier = 1,
		name_id = "buff_tag_team_name",
		priority = 3
	},
	["pocket_ecm_jammer"] = {
		icon_type = "perk",
		priority = 5,
		icon_id = 21,--"pocket_ecm_jammer",
		icon_tier = 1,
		name_id = "buff_pocket_ecm_jammer_name"
	},
	["pocket_ecm_jammer_feedback"] = {
		icon_type = "perk",
		priority = 5,
		icon_id = 21,--"pocket_ecm_jammer",
		icon_tier = 1,
		name_id = "buff_pocket_ecm_feedback_name"
	},
	["pocket_ecm_kill_dodge"] = {
		icon_type = "perk",
		priority = 3,
		icon_id = 21,--"pocket_ecm_jammer",
		icon_tier = 7,
		name_id = "buff_pocket_ecm_dodge_name"
	},
	--[[
	["flashbang"] = {
		icon_type = "icon", --where to get icon (not directly related to where ingame buff came from)
		priority = 7,
		icon_id = "concussion_grenade", --if no source is specified, use this icon tweak data
--		icon_rect = {1,7}, --if source is "manual" then use "icon" as path and "icon_rect" to find bitmap
		name_id = "noblehud_buff_flashbang_label", --display name
		label_compact = "$TIMER",
		text_color = Color.black:with_alpha(0.3),
		icon_color = NobleHUD.color_data.hud_buff_negative,
		value_type = "timer", --value calculation type
		flash = true --alpha sine flash if true
	},
	--]]
	--[[
	["downed"] = { --i think people will probably figure out that they've been downed, actually. unless they're flashbanged.
		icon_type = "icon",
		priority = 3,
		disabled = true,
		icon_id = "mugshot_downed",
		icon_rect = {240,464,48,48},
		name_id = "downed",
		label_compact = "$TIMER",
		text_color = NobleHUD.color_data.hud_buff_negative,
		value_type = "timer",
		duration = 30,
		flash = false
	},
	--]]
	--[[
	["tased"] = {
		icon_type = "icon",
		priority = 3,
		icon_id = "mugshot_electrified",--skill icon "insulation",
		name_id = "noblehud_buff_tased_label"
	},
	["electrocuted"] = {
		icon_type = "icon",
		priority = 3,
		icon_id = "mugshot_electrified",
		name_id = "noblehud_buff_electrocuted_label",
		label_compact = "$TIMER",
		icon_color = Color.yellow,
		text_color = NobleHUD.color_data.hud_buff_negative,
		value_type = "timer",
		flash = true
	}, 
	--]]
	["swan_song"] = {
		icon_type = "skill",
		priority = 3,
		icon_id = "perseverance",
		duration = 3, --6 aced
		name_id = "buff_swan_song_name"
	},
	["messiah_charge"] = {
		icon_type = "skill",
		priority = 2,
		icon_id = "messiah",
		name_id = "buff_messiah_name"
	},
	["messiah"] = {
		icon_type = "skill",
		priority = 1,
		icon_id = "messiah",
		name_id = "buff_messiah_name"
	},
	["bullseye"] = {
		icon_type = "skill",
		priority = 5,
		icon_id = "prison_wife",
		icon_rect = {6,11},
		name_id = "buff_bullseye_name",
		color_type = "cooldown",
		duration = 2.5
	},
	["uppers_aced_cooldown"] = {
		icon_type = "skill",
		priority = 2,
		icon_id = "tea_cookies",
		name_id = "buff_uppers_aced_cooldown_name",
		color_type = "cooldown"
	},
	["uppers_ready"] = {
		icon_type = "skill",
		priority = 2,
		icon_id = "tea_cookies",
		name_id = "buff_uppers_aced_ready_name"
	},
	["berserker_damage_multiplier"] = {
		icon_type = "skill",
		priority = 2,
		icon_id = "wolverine",
		name_id = "buff_berserker_ranged_name",
		flash = true
	},
	["berserker_melee_damage_multiplier"] = {
		icon_type = "skill",
		priority = 2,
		icon_id = "wolverine",
		name_id = "buff_berserker_melee_name"
	},
	["bullet_storm"] = {
		icon_type = "skill",
		priority = 3,
		icon_id = "ammo_reservoir",
		icon_rect = {0,3},
		name_id = "buff_bullet_storm_name"
	},
	["unseen_strike"] = {
		icon_type = "skill",
		priority = 3,
		icon_id = "unseen_strike",
		name_id = "buff_unseen_strike_name"
	},
	["overkill_damage_multiplier"] = {
		icon_type = "skill",
		priority = 3,
		icon_id = "overkill",
		name_id = "buff_overkill_damage_multiplier_name"
	},
	["bloodthirst_melee"] = {
		icon_type = "skill",
		priority = 3,
		disabled = false,
		icon_id = "bloodthirst", --assassin?
		name_id = "buff_bloodthirst_melee_name"
	},
	["bloodthirst_reload_speed"] = {
		icon_type = "skill",
		priority = 4,
		icon_id = "bloodthirst",
		icon_rect = {1,7},
		duration = 10,
		name_id = "buff_bloodthirst_reload_name"
	},
	["team_damage_speed_multiplier_received"] = {
		icon_type = "skill",
		priority = 5,
		icon_id = "scavenger",
		icon_rect = {10,9},
		duration = 5,
		name_id = "buff_second_wind_name"
	},
	["damage_speed_multiplier"] = {
		icon_type = "skill",
		priority = 5,
		icon_id = "scavenger",
		icon_rect = {10,9},
		duration = 5,
		name_id = "buff_second_wind_name"
	},
	["sixth_sense"] = {
		icon_type = "skill",
		priority = 7,
		icon_id = "chameleon",
		name_id = "buff_sixth_sense_name",
		persistent_timer = true
	},
	["revive_damage_reduction"] = { --combat medic
		icon_type = "skill",
		priority = 5,
		icon_id = "combat_medic",
		icon_rect = {5,7},
		duration = 5,
		name_id = "buff_combat_medic_name"
	},
	["trigger_happy"] = {
		icon_type = "skill",
		priority = 3,
		icon_id = "trigger_happy",
		name_id = "buff_trigger_happy_name",
		duration = 2 --4 aced
	},
	["desperado"] = {
		icon_type = "skill",
		priority = 3,
		icon_id = "expert_handling",
		name_id = "buff_desperado_name",
		label_compact = "$TIMER",
		value_type = "timer",
		duration = 10,
		flash = false
	},
	["partners_in_crime"] = {
		icon_type = "skill",
		priority = 3,
		icon_id = "control_freak",
		name_id = "buff_partners_in_crime_name"
	},
	["partners_in_crime_aced"] = {
		icon_type = "skill",
		priority = 3,
		disabled = true, --same proc conditions as basic
		icon_id = "control_freak",
		name_id = "buff_partners_in_crime_name"
	},
	["single_shot_fast_reload"] = {
		icon_type = "skill",
		priority = 5,
		icon_id = "speedy_reload",
		duration = 4,
		name_id = "buff_aggressive_reload_name"
	},
	["shock_and_awe_reload_multiplier"] = { --auto multikills reload speed from skilltree "lock n load"
		icon_type = "skill",
		priority = 5,
		icon_id = "shock_and_awe",
		name_id = "buff_lock_n_load_name"
	},
	["dmg_multiplier_outnumbered"] = { --underdog dmg boost
		icon_type = "skill",
		priority = 7,
		icon_id = "underdog",
		name_id = "buff_underdog_name"
	},
	["dmg_dampener_outnumbered"] = { --underdog dmg resist
		icon_type = "skill",
		priority = 7,
		disabled = true,
		icon_id = "underdog",
		name_id = "buff_underdog_name"
	},
	["dmg_dampener_close_contact"] = { --dmg resist; activates in conjuction with underdog but lasts 5 seconds??? ovk y u do dis
		icon_type = "skill",
		priority = 7,
		disabled = true,
		icon_id = "underdog",
		name_id = "buff_underdog_name"
	},	
	["dmg_dampener_outnumbered_strong"] = { --same as above, but aced
		icon_type = "skill",
		priority = 7,
		disabled = true,
		icon_id = "underdog",
		name_id = "buff_underdog_name"
	},
	["combat_medic_damage_multiplier"] = {
		priority = 5,
		disabled = true
	},
	["combat_medic_enter_steelsight_speed_multiplier"] = {
		priority = 5,
		disabled = true
	},
	--[[
	["stockholm_ready"] = {
		disabled = true,
		priority = 2,
		value_type = "status"
	},
	--]]
	["first_aid_damage_reduction"] = { --120s 10% damage reduction from using fak/docbag
		icon_type = "skill",
		priority = 3,
		icon_id = "tea_time",
		icon_rect = {1,11},
		name_id = "buff_quick_fix_name"
	},
	["reload_weapon_faster"] = { --running from death basic, part 1
		icon_type = "skill",  --reload + swap faster after revive
		priority = 3,
		icon_id = "running_from_death", --or speedy_reload
		duration = 10,
		name_id = "buff_running_from_death_name"
	},
	["swap_weapon_faster"] = { --running from death basic, part 2; disabled due to identical proc conditions + duration
		disabled = true,
		icon_type = "skill",
		priority = 3,
		icon_id = "speedy_reload",
		duration = 10,
		name_id = "buff_running_from_death_name"
	},
	["increased_movement_speed"] = { --running from death aced; disabled due to identical proc conditions + duration
		disabled = true,
		icon_type = "skill",
		priority = 3,
		icon_id = "running_from_death",
		duration = 10,
		name_id = "buff_running_from_death_name"
	},
	["revived_damage_resist"] = { --up you go basic
		icon_type = "skill",
		priority = 3,
		icon_id = "up_you_go",
		icon_rect = {11,4},
		duration = 10,
		name_id = "buff_up_you_go_name"
	}
}





local buff_data = {
	buffs = buffs,
	categories = {}
}

return buff_data