/datum/job/roguetown/thief_guild_master
	title = "Nachtfuchs"
	flag = THIEFGUILDMASTER
	department_flag = THIEFGUILD
	faction = "Station" // what
	total_positions = 1
	spawn_positions = 1
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	allowed_sexes = list(MALE, FEMALE)
	display_order = JDO_THIEFGUILDMASTER
	outfit = /datum/outfit/job/roguetown/thief_guild_master
	give_bank_account = FALSE
	same_job_respawn_delay = 30 MINUTES
	job_traits = list(TRAIT_DODGEEXPERT, TRAIT_SEEPRICES, TRAIT_LIGHT_STEP)

/datum/advclass/thief_guild_master
	name = "Nachtfuchs"
	tutorial = "Coin, Coin, Coin! Oh beautiful coin: You're addicted to it, and you hold the position as the Grand Duke's personal treasurer of both coin and information. You know the power silver and gold has on a man's mortal soul, and you know just what lengths they'll go to in order to get even more. Keep your festering economy alive- for it is the only thing you can weigh any trust into anymore."
	outfit = /datum/outfit/job/roguetown/steward/basic

	category_tags = list(CTAG_STEWARD)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
		STATKEY_CON = 1,
		STATKEY_STR = -2
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)
