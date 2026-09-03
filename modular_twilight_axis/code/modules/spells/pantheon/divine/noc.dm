/////////////////////
// T0 - Noc Sight. //
/////////////////////

/datum/action/cooldown/spell/noc/TAsight
	name = "Noc's Gaze"
	desc = "Peer ahead. (Use MMB to project your vision as if you had a very high perception.)"
	button_icon_state = "noc_sight"
	glow_intensity = GLOW_INTENSITY_LOW
	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE
	primary_resource_cost = SPELLCOST_CANTRIP
	secondary_resource_cost = SPELLCOST_CANTRIP
	invocation_type = INVOCATION_WHISPER
	invocations = list("Noc guide my gaze.")
	charge_required = FALSE
	cooldown_time = 5 SECONDS

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/TAsight/cast(atom/cast_on)
	. = ..()
	if(isturf(cast_on) && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		var/turf/T = cast_on
		var/_x = T.x-H.loc.x
		var/_y = T.y-H.loc.y
		var/ttime = 6
		var/dist = get_dist(H, T)
		if(dist > 7 || dist  <= 2)
			return
		H.hide_cone()
		var/offset = 5
		if(_x > 0)
			_x += offset
		else if(_x != 0)
			_x -= offset
		if(_y > 0)
			_y += offset
		else if(_y != 0)
			_y -= offset
		animate(H.client, pixel_x = world.icon_size*_x, pixel_y = world.icon_size*_y, ttime)
		H.update_cone_show()
		return TRUE
	return FALSE

/////////////////////////
// T0 - Nitesight. //////
/////////////////////////

/datum/action/cooldown/spell/darkvision/miracle
	name = "Nitesight"
	background_icon = 'icons/mob/actions/nocmiracles.dmi'
	invocations = list("Noc, grant me clarity.") //Nachtsicht. Night Sight
	button_icon_state = "darkvision"
	point_cost = 0
	spell_tier = 0
	associated_skill = null

/////////////////////////
// T1 - Enlightenment. //
/////////////////////////

/datum/action/cooldown/spell/noc/TAenlightenment
	name = "Enlightenment"
	desc = "Invoke a lesser form of the Moonlight Dance, temporarily increasing intelligence of your target. \
	Scales with holy skill and grows much more effective at nite."
	button_icon_state = "noc_gaze"
	sound = 'sound/magic/clang.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_STAT_BUFF
	secondary_resource_cost = SPELLCOST_STAT_BUFF

	invocation_type = INVOCATION_SHOUT
	invocations = list("His gaze upon me...!", "I beseech the stars; show me truth!")

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	charge_then_click = TRUE
	cooldown_time = 2 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/TAenlightenment/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/skill_level = H.get_skill_level(associated_skill)
	var/mob/living/spelltarget = cast_on

	if(spelltarget != H)
		H.visible_message("[H] mutters an incantation and [spelltarget] briefly shines green.")
		to_chat(H, span_notice("With another person as a conduit, my spell's duration is extended."))
		spelltarget.apply_status_effect(/datum/status_effect/buff/TAwise_moon, skill_level)
	else
		H.visible_message("[H] mutters an incantation and they briefly shine green.")
		spelltarget.apply_status_effect(/datum/status_effect/buff/TAwise_moon, skill_level)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/TAwise_moon
	name = "Enlightenment"
	desc = "Divine magic is boosting my intelligence."
	icon_state = "enlightenment"

/datum/status_effect/buff/TAwise_moon
	id = "wise_moon"
	alert_type = /atom/movable/screen/alert/status_effect/buff/TAwise_moon
	duration = 2 MINUTES

/datum/status_effect/buff/TAwise_moon/on_creation(mob/living/new_owner, assocskill)
	var/int_bonus = 0
	if(assocskill)
		int_bonus = 2
		if(assocskill >= 4)
			int_bonus = 3
	if(GLOB.tod == "night")
		if(assocskill <= 2)
			int_bonus = 3
		else
			int_bonus = assocskill
		duration *= 2
	if(GLOB.tod == "day")
		to_chat(owner, span_warning("ASTRATA IS RISEN! My spell loses some of its potency! (-1 TO STAT BOOST.)"))
		int_bonus--
	if(int_bonus > 0)
		effectedstats = list(STATKEY_INT = int_bonus)
	. = ..()

///////////////////////
// T1 - Inspiration. //
///////////////////////

/datum/action/cooldown/spell/noc/TAinspiration
	name = "Inspiration"
	desc = "Touch a target. Their next dream will be inspired, granting more dream-points to the target and a few to yourself. \
	This spell will fail if it's dae or dawn. Points granted scales with holy skill."
	button_icon_state = "moondream"
	sound = 'sound/magic/owlhoot.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_MIRACLE_MINOR

	invocation_type = INVOCATION_WHISPER
	invocations = list("Good nite.")

	charge_required = FALSE
	cooldown_time = 25 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/TAinspiration/cast(atom/cast_on)
	. = ..()
	if(isliving(cast_on))
		var/mob/living/carbon/human/target = cast_on
		var/mob/living/carbon/human/H = owner
		if(!target.mind)
			to_chat(owner, span_warning("They are too simple for this spell to work!"))
			return FALSE
		if(GLOB.tod == "day" || GLOB.tod == "dawn")
			to_chat(owner, span_warning("ASTRATA IS RISEN! MY SPELL FIZZLES!"))
			return FALSE
		if(target.mind?.sleep_adv)
			owner.visible_message(span_blue("[owner] draws a glowing blue crescent on [target]\'s forehead!"))
			to_chat(target, span_blue("My mind flashes with inspiring images of the NOCMOS! My dreams will prove fruitful...!"))
			target.mind.sleep_adv.sleep_adv_points += H.get_skill_level(associated_skill)
			H.mind.sleep_adv.sleep_adv_points += floor(H.get_skill_level(associated_skill)/2)
		return TRUE
	return FALSE

////////////////////////
// T2 - Invisibility. //
////////////////////////

/datum/action/cooldown/spell/noc/invisibility
	name = "Invisibility"

/////////////////////
// T2 - Blindness. //
/////////////////////

/datum/action/cooldown/spell/noc/TAblindness
	name = "Blindness"
	desc = "Direct a mote of living darkness to temporarily blind another. \n(-3 PERCEPTION, BLINDNESS)"
	button_icon_state = "blindness"
	sound = 'sound/magic/churn.ogg'
	glow_intensity = GLOW_INTENSITY_LOW
	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE
	primary_resource_cost = SPELLCOST_MIRACLE
	secondary_resource_cost = SPELLCOST_MIRACLE
	invocation_type = INVOCATION_SHOUT
	invocations = list("Blackest nite, blind!")
	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 1.5 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/TAblindness/cast(atom/cast_on)
	. = ..()
	var/mob/living/spelltarget = cast_on

	if(isliving(cast_on))
		if(spelltarget.anti_magic_check(TRUE, TRUE))
			return FALSE
		if(spell_guard_check(cast_on, TRUE))
			cast_on.visible_message(span_warning("[cast_on] shields their eyes from the darkness!"))
			return TRUE
		var/assocskill = owner.get_skill_level(associated_skill)
		cast_on.visible_message(span_warning("[owner] points at [cast_on]'s eyes!"), span_userdanger("[owner] points at my eyes! Shadowy fingers are digging into my vision-- I can't SEE!"))
		spelltarget.apply_status_effect(/datum/status_effect/debuff/TAblindness, assocskill)
		spelltarget.flash_act()
		return TRUE
	else
		return FALSE

/atom/movable/screen/alert/status_effect/debuff/TAblindness
	name = "Blindness"
	desc = "I see naught but darkness! (-3 PER, blindness)"

/datum/status_effect/debuff/TAblindness
	id = "blindness"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/TAblindness
	effectedstats = list(STATKEY_PER = -3)

/datum/status_effect/debuff/TAblindness/on_creation(mob/living/new_owner, assocskill)
	// Guaranteed at least five seconds. Technically not needed but Just In CaseTM.
	if(assocskill)
		duration = clamp(assocskill*5, 5, 30) * 1 SECONDS
	else
		duration = 5 SECONDS // Just in case someone somehow gets this W/O holy skill.
	. = ..()

/datum/status_effect/debuff/TAblindness/on_remove()
	. = ..()
	to_chat(owner, span_warning("My vision returns...!"))

//////////////////////
// T3 - Moonscorch. //
//////////////////////

/datum/action/cooldown/spell/noc/TAmoonscorch
	name = "Moonscorch"
	desc = "Calls down shimmering moonlight onto those around you in a certain radius, scaling with holy skill. \
	Mindless creachers will become critically weak. Simple creachers will burn. \
	Does not work during dae nor dawn."
	button_icon_state = "moon_light"
	sound = 'sound/magic/churn.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_AURA
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR

	secondary_resource_cost = SPELLCOST_MIRACLE

	invocation_type = INVOCATION_SHOUT
	invocations = list("YOUR TRUE FORM REVEALED!!")

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 1 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/TAmoonscorch/cast(atom/cast_on)
	. = ..()

	if(GLOB.tod == "day" || GLOB.tod == "dawn")
		to_chat(owner, span_warning("ASTRATA IS RISEN! MY SPELL FIZZLES!"))
		return FALSE
	var/checkrange = (cast_range + owner.get_skill_level(/datum/skill/magic/holy)) //+1 range per holy skill up to a potential of 8.
	for(var/mob/living/M in range(checkrange, owner))
		if(M == owner)
			continue
		var/target_turf = get_turf(M)
		new /obj/effect/temp_visual/TAmoon(target_turf)
		M.apply_status_effect(/datum/status_effect/light_buff/TAmoon, 1)
	return TRUE

/obj/effect/temp_visual/TAmoon
	icon_state = "moon"
	duration = 4 SECONDS
	layer = MASSIVE_OBJ_LAYER
	light_outer_range = 3
	light_color = "#1640d7ff"

/datum/status_effect/light_buff/TAmoon
	id = "moon_light_buff"
	alert_type = /atom/movable/screen/alert/status_effect/light_buff
	duration = 15 SECONDS//This is geniunely permanent, I guess dude?
	color_mob_light = "#3936eacf"

/datum/status_effect/light_buff/TAmoon/on_apply()
	..()
	if(!owner.mind) //PVE stuff.
		if(HAS_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS)) //skeletons...
			return
		ADD_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, TRAIT_MIRACLE)

/datum/status_effect/light_buff/TAmoon/tick()
	if(!owner.mind || istype(owner, /mob/living/simple_animal)) //AI mobs take 3 burn damage per tick. 45 burn without 15 seconds.
		var/mob/living/target = owner
		target.adjustFireLoss(3)

/datum/action/cooldown/spell/noc/spellpack
	desc = "Allows you to learn a set of spells. \n \
	<b>MAGISTER</b>: Greater Arcyne Bolt, Arc Bolt, Phase, Message, Campfire \n \
	<b>ENCHANTER</b>: Gravel Blast, Mending, Arcyne Forge, Forcewall, Attune: Hawk, Blood Rush, Conjure Crystalhide Ward. \n \
	<b>SEER</b>: Attune Giant, Guidance, Attune Haste, Conjure Crystalhide Ward."

	magister_bundle = list(
		/datum/action/cooldown/spell/projectile/greater_arcyne_bolt,
		/datum/action/cooldown/spell/projectile/arc_bolt,
		/datum/action/cooldown/spell/phase,
		/datum/action/cooldown/spell/message,
		/datum/action/cooldown/spell/create_campfire
	)
	enchanter_bundle = list(
		/datum/action/cooldown/spell/projectile/gravel_blast, //Offensive Tool
		/datum/action/cooldown/spell/conjure_arcyne_ward/dragonhide,
		/datum/action/cooldown/spell/mending,
		/datum/action/cooldown/spell/arcyne_forge, //Utility
		/datum/action/cooldown/spell/augment_buff/attune_hawk,
		/datum/action/cooldown/spell/augment_buff/blood_rush //Buff
	)
	seer_bundle = list(
		/datum/action/cooldown/spell/conjure_arcyne_ward/crystalhide,
		/datum/action/cooldown/spell/augment_buff/attune_giant,
		/datum/action/cooldown/spell/augment_buff/guidance,
		/datum/action/cooldown/spell/augment_buff/attune_haste,
		/datum/action/cooldown/spell/augment_buff/fortitude,
		/datum/action/cooldown/spell/mindlink,
	)


////////////////////////
// T3 - Noc's Secret. //
////////////////////////

/datum/action/cooldown/spell/noc/grimoire
	name = "Noc's Secret"
	desc = "You create a scroll, which you need to fill with three skills of your choice. \
			You do not need to know these skills, and you too can read this scroll. \
			Anyone who reads this scroll will increase the skill levels of these skills up to Journeyman. \
			Each person cannot read more than one scroll."
	button_icon_state = "noc"
	click_to_activate = FALSE
	primary_resource_cost = SPELLCOST_MIRACLE_LEGENDARY*2
	secondary_resource_cost = SPELLCOST_MIRACLE_LEGENDARY
	invocation_type = INVOCATION_SHOUT
	invocations = list("Deepest dreaming, scribe!")
	cooldown_time = 15 MINUTES
	charge_required = FALSE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/grimoire/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	new /obj/item/book/granter/skill(H.loc)
	H.visible_message("[H] kneels his head in prayer, creating an arcane scroll on the ground!")
	return TRUE

#define TRAIT_NOC_ARCANE_SCROLL_READED "noc_arcane_scroll_readed"

GLOBAL_LIST_INIT(noc_scroll_skills, list(
	"Knives" = /datum/skill/combat/knives,
	"Swords" = /datum/skill/combat/swords,
	"Polearms" = /datum/skill/combat/polearms,
	"Maces" = /datum/skill/combat/maces,
	"Axes" = /datum/skill/combat/axes,
	"Whips & Flails" = /datum/skill/combat/whipsflails,
	"Archery" = /datum/skill/combat/bows,
	"Crossbows" = /datum/skill/combat/crossbows,
	"Wrestling" = /datum/skill/combat/wrestling,
	"Unarmed" = /datum/skill/combat/unarmed,
	"Shields" = /datum/skill/combat/shields,
	"Slings" = /datum/skill/combat/slings,
	"Staves" = /datum/skill/combat/staves,
	"Arcyne Armaments" = /datum/skill/combat/arcyne,
	"Crafting" = /datum/skill/craft/crafting,
	"Weaponsmithing" = /datum/skill/craft/weaponsmithing,
	"Armorsmithing" = /datum/skill/craft/armorsmithing,
	"Blacksmithing" = /datum/skill/craft/blacksmithing,
	"Smelting" = /datum/skill/craft/smelting,
	"Carpenty" = /datum/skill/craft/carpentry,
	"Masonry" = /datum/skill/craft/masonry,
	"Trapmaking" = /datum/skill/craft/traps,
	"Engineering" = /datum/skill/craft/engineering,
	"Cooking" = /datum/skill/craft/cooking,
	"Sewing" = /datum/skill/craft/sewing,
	"Skincrafting" = /datum/skill/craft/tanning,
	"Pottery" = /datum/skill/craft/ceramics,
	"Alchemy" = /datum/skill/craft/alchemy,
	"Farming" = /datum/skill/labor/farming,
	"Mining" = /datum/skill/labor/mining,
	"Fishing" = /datum/skill/labor/fishing,
	"Butchering" = /datum/skill/labor/butchering,
	"Lumberjacking" = /datum/skill/labor/lumberjacking,
	"Miracles" = /datum/skill/magic/holy,
	"Arcana" = /datum/skill/magic/arcane,
	"Athletics" = /datum/skill/misc/athletics,
	"Climbing" = /datum/skill/misc/climbing,
	"Literacy" = /datum/skill/misc/reading,
	"Swimming" = /datum/skill/misc/swimming,
	"Pickpocketing" = /datum/skill/misc/stealing,
	"Sneaking" = /datum/skill/misc/sneaking,
	"Lockpicking" = /datum/skill/misc/lockpicking,
	"Riding" = /datum/skill/misc/riding,
	"Music" = /datum/skill/misc/music,
	"Medicine" = /datum/skill/misc/medicine,
	"Tracking" = /datum/skill/misc/tracking,
	"Hunting" = /datum/skill/misc/hunting
))

/obj/item/book/granter/skill
	name = "Noc's Arcane Scroll"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scrolldarkred"
	var/datum/skill/first_skill
	var/datum/skill/second_skill
	var/datum/skill/third_skill
	var/currently_choosing = FALSE

/obj/item/book/granter/skill/examine(mob/user)
	. = ..()
	if(first_skill)
		. += span_info("First skill that this scroll teaches is [first_skill.name]")
	if(second_skill)
		. += span_info("Secon skill that this scroll teaches is [second_skill.name]")
	if(third_skill)
		. += span_info("Third skill that this scroll teaches is [third_skill.name]")

/obj/item/book/granter/skill/attack_self(mob/living/user)
	if(!first_skill || !second_skill || !third_skill)
		if(currently_choosing)
			return FALSE
		choose_skill(user)
		return TRUE
	return ..()

/obj/item/book/granter/skill/proc/choose_skill(mob/living/user)
	var/list/current_list = list(GLOB.noc_scroll_skills)
	var/choice = tgui_input_list(user, "Choose your skill", "Skill", current_list)
	currently_choosing = TRUE
	if(!choice || QDELETED(src))
		currently_choosing = FALSE
		return FALSE
	if(choice == first_skill || choice == second_skill || choice == third_skill)
		to_chat(user, span_warning("You’ve already writen this skill..."))
		return FALSE

	var/datum/skill/choosen_skill = current_list[choice]
	return choose_slot_for_skill(user, choosen_skill)

/obj/item/book/granter/skill/proc/choose_slot_for_skill(mob/living/user, datum/skill/choosen_skill)
	var/static/list/slots = list(
		"First Scroll Skill",
		"Second Scroll Skill",
		"Third Scroll Skill",
	)
	var/choice = tgui_input_list(user, "Choose your slot", "Slots", slots)
	if(!choice || QDELETED(src))
		currently_choosing = FALSE
		return FALSE

	switch(choice)
		if("First Scroll Skill")
			first_skill = choosen_skill
		if("Second Scroll Skill")
			second_skill = choosen_skill
		if("Third Scroll Skill")
			third_skill = choosen_skill
	currently_choosing = FALSE

	return TRUE

/obj/item/book/granter/skill/already_known(mob/user)
	var/mob/living/carbon/human/reader = user
	if(HAS_TRAIT(reader, TRAIT_NOC_ARCANE_SCROLL_READED))
		to_chat(reader, span_warning("You are not supposed to know any more than this."))
		return TRUE
	if(reader.get_skill_level(first_skill) >= 3)
		to_chat(reader, span_warning("The information in this scroll is of no use to you..."))
		return TRUE
	if(reader.get_skill_level(second_skill) >= 3)
		to_chat(reader, span_warning("The information in this scroll is of no use to you..."))
		return TRUE
	if(reader.get_skill_level(third_skill) >= 3)
		to_chat(reader, span_warning("The information in this scroll is of no use to you..."))
		return TRUE
	return FALSE

/obj/item/book/granter/skill/on_reading_start(mob/user)
	to_chat(user, span_notice("I start reading about secrets of knowledge..."))

/obj/item/book/granter/skill/on_reading_finished(mob/user)
	to_chat(user, span_notice("The information you received has borne fruit!"))
	var/mob/living/carbon/human/reader = user
	reader.adjust_skillrank(first_skill, 1, FALSE)
	reader.adjust_skillrank(second_skill, 1, FALSE)
	reader.adjust_skillrank(third_skill, 1, FALSE)
	ADD_TRAIT(reader, TRAIT_NOC_ARCANE_SCROLL_READED, TRAIT_GENERIC)
	onlearned()

/obj/item/book/granter/skill/onlearned(mob/user)
	used = TRUE
	qdel(src)

#undef TRAIT_NOC_ARCANE_SCROLL_READED

// That's one in fact is not Noc changes, but it’s related to that.

/datum/action/cooldown/spell/undivided/undivided_spellpack
	miracle_generalist_bundle = list(
		/datum/action/cooldown/spell/noc/TAinspiration::name			= /datum/action/cooldown/spell/noc/TAinspiration,
		/datum/action/cooldown/spell/darkvision/undivided::name		= /datum/action/cooldown/spell/darkvision/undivided,
		/datum/action/cooldown/spell/noc/invisibility::name			= /datum/action/cooldown/spell/noc/invisibility,
		/obj/effect/proc_holder/spell/targeted/blesscrop::name		= /obj/effect/proc_holder/spell/targeted/blesscrop,
		/obj/effect/proc_holder/spell/invoked/eora_blessing::name	= /obj/effect/proc_holder/spell/invoked/eora_blessing,
		/datum/action/cooldown/spell/arcyne_forge/miracle::name		= /datum/action/cooldown/spell/arcyne_forge/miracle,
	)
	miracle_acolyte_bundle = list(
		/obj/effect/proc_holder/spell/invoked/diagnose::name			= /obj/effect/proc_holder/spell/invoked/diagnose,
		/datum/action/cooldown/spell/noc/TAblindness::name				= /datum/action/cooldown/spell/noc/TAblindness,
		/obj/effect/proc_holder/spell/invoked/bless_food::name			= /obj/effect/proc_holder/spell/invoked/bless_food,
		/obj/effect/proc_holder/spell/invoked/avert::name				= /obj/effect/proc_holder/spell/invoked/avert,
		/obj/effect/proc_holder/spell/invoked/attach_bodypart::name		= /obj/effect/proc_holder/spell/invoked/attach_bodypart,
	)
	miracle_templar_bundle = list(
		/obj/effect/proc_holder/spell/invoked/abyssor_undertow::name		= /obj/effect/proc_holder/spell/invoked/abyssor_undertow,
		/datum/action/cooldown/spell/ravox/withstand::name					= /datum/action/cooldown/spell/ravox/withstand,
		/datum/action/cooldown/spell/mending/malum::name					= /datum/action/cooldown/spell/mending/malum,
		/datum/action/cooldown/spell/noc/TAenlightenment::name				= /datum/action/cooldown/spell/noc/TAenlightenment,
		/obj/effect/proc_holder/spell/invoked/vendetta::name				= /obj/effect/proc_holder/spell/invoked/vendetta,
	)
