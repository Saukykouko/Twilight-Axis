/datum/advclass/gnoll/templar
	reset_stats = FALSE

	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_SPD = 2,
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
	)

	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
	)

/datum/advclass/gnoll/shaman
	reset_stats = FALSE

	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
		STATKEY_INT = 2,
		STATKEY_STR = 1
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/hunting = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/gnoll/shaman/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/gnoll)
		H.skin_armor = new vamp_armor_type(H)
		H.AddComponent(/datum/component/vampiric_striker, shard_threshold, shard_repair_value, max_fury_stacks)
		var/obj/item/ritechalk/chalk = new /obj/item/ritechalk(H.loc)
		H.put_in_r_hand(chalk)
		neck = /obj/item/storage/belt/rogue/pouch/healing
		backr = /obj/item/storage/backpack/rogue/satchel/gnoll
		don_pelt(H)
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE)
		H.mind?.AddSpell(new /datum/action/cooldown/spell/convert_heretic)
		H.mind?.AddSpell(new /datum/action/cooldown/spell/projectile/unholy_blast)
		H.mind?.RemoveSpell(/obj/effect/proc_holder/spell/self/claws/gnoll)
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/claws/gnoll/shaman)

/obj/effect/proc_holder/spell/self/claws/gnoll/shaman
	claw_type = /obj/item/rogueweapon/werewolf_claw/gnoll/shaman

/obj/item/rogueweapon/werewolf_claw/gnoll/shaman
	wdefense = 4
	wbalance = WBALANCE_NORMAL

/datum/advclass/gnoll/knight
	reset_stats = FALSE

	subclass_stats = list(
		STATKEY_WIL = 5,
		STATKEY_CON = 5,
		STATKEY_SPD = 2,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
	)

	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/advclass/gnoll/berserker
	reset_stats = FALSE

	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_SPD = 3,
		STATKEY_INT = -1,
		STATKEY_PER = -1
	)

	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/species/gnoll
	inherent_traits = list(
		TRAIT_LONGSTRIDER,
		TRAIT_NO_VOICEPACK_OVERRIDE, //They have voicepack lines.
		TRAIT_IGNORESLOWDOWN,
		TRAIT_IGNOREDAMAGESLOWDOWN,
		TRAIT_NOFALLDAMAGE1,
		TRAIT_STRENGTH_UNCAPPED,
		TRAIT_HARDDISMEMBER,
		TRAIT_NOSTINK,
		TRAIT_NASTY_EATER,
		TRAIT_ORGAN_EATER,
		TRAIT_STEELHEARTED,
		TRAIT_BASHDOORS,
		TRAIT_STRONGBITE,
		TRAIT_GNARLYDIGITS,
		TRAIT_NUDIST,
		TRAIT_HERESIARCH, //Just because I'm putting their spawns here, that's all.
		TRAIT_ZURCH,
		TRAIT_UNLYCKERABLE, //Just stop
		TRAIT_NOWW,
		TRAIT_MASTERFUL_HUNTER,
		TRAIT_TOUGH_COOKIE,
		TRAIT_HARDSOLE,
		TRAIT_BLOOD_RESISTANCE,
		TRAIT_NOPAIN,
	)

/datum/charflaw/targeted
	name = "Targeted (+2 TRI)"
	desc = "Someone, somewhere, has offered up my name to the Bloodsworn of Graggar. You will be hunted by Gnolls and Assassin. \
	Assassins will seek my skin-and-soul to steal-and-bind." + span_artery("\nHaving this vice will add you to a list of targets hunted by a powerful \
	class. If they are successful in killing you, you may be round-removed for a time, though you will be recoverable if the assassin is slain and \
	their dagger is broken.") + span_danger("\nAssassins DO-NOT NEED to ESCALATE against you if you have this vice. To reiterate: please expect \
	random attacks and-or potential round removal, even if not permanent. You are still granted ERP protection.")

/datum/charflaw/targeted/on_mob_creation(mob/user)
	. = ..()
	user.adjust_triumphs(2)

/datum/job/roguetown/assassin
	vice_restrictions = list(/datum/charflaw/targeted)

/datum/job/roguetown/greater_skeleton
	vice_restrictions = list(/datum/charflaw/targeted)

/datum/job/roguetown/greater_skeleton/lich
	vice_restrictions = list(/datum/charflaw/targeted, /datum/charflaw/wanted)

/datum/job/roguetown/gnoll
	vice_restrictions = list(/datum/charflaw/targeted)

/datum/job/roguetown/hag
	vice_restrictions = list(/datum/charflaw/targeted, /datum/charflaw/wanted) // could you fucking imagine

/datum/job/roguetown/greater_skeleton/siege_skeleton
	vice_restrictions = list(/datum/charflaw/targeted)

/datum/migrant_role/assassin
	banned_flaws = list(/datum/charflaw/targeted)

/datum/migrant_role/gnoll
	banned_flaws = list(/datum/charflaw/targeted)
