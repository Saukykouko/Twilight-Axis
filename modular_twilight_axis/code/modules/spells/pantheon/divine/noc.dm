/////////////////////////
// T0 - Nitesight. //////
/////////////////////////

/datum/action/cooldown/spell/noc/nitevision
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	button_icon_state = "darkvision"

/////////////////////
// T1 - Noc Gaze. //
/////////////////////

/datum/action/cooldown/spell/noc/TAbless
	name = "Noc's Bless"
	desc = "Noc grants a powerful blessing upon the chosen target, which increases the stats depending on the time of dae... Or nite. \n\
		becomes better if caster has Tier 4 Miracles."
	button_icon_state = "noc_sight"
	glow_intensity = GLOW_INTENSITY_LOW
	click_to_activate = TRUE
	self_cast_possible = TRUE
	cast_range = SPELL_RANGE_AURA
	primary_resource_cost = SPELLCOST_CANTRIP
	secondary_resource_cost = SPELLCOST_CANTRIP
	invocation_type = INVOCATION_WHISPER
	invocations = list("Dae and nite, dawn and dusk, Noc will not forget us all.")
	charge_required = TRUE
	charge_time = 2 SECONDS
	cooldown_time = 1 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/TAbless/cast(atom/cast_on)
	. = ..()
	var/mob/living/spelltarget = cast_on
	if(!isliving(spelltarget))
		to_chat(owner, span_warning("Must be living!"))
		return FALSE
	if(!spelltarget.mind)
		to_chat(owner, span_warning("The target's mind is too simple for Noc's Bless!"))
		return FALSE
	if(spelltarget.has_status_effect(/datum/status_effect/buff/TAnoc_bless))
		to_chat(owner, span_warning("The target already has Blessing."))
		return FALSE

	var/mob/living/carbon/human/H = owner
	var/datum/devotion/D = H.devotion
	spelltarget.apply_status_effect(/datum/status_effect/buff/TAnoc_bless, D)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/TAnoc_bless
	name = "Noc's Bless"
	desc = "Noc's blessing grants me everything I need to move forward."
	icon_state = "enlightenment"

/datum/status_effect/buff/TAnoc_bless
	id = "noc_bless"
	alert_type = /atom/movable/screen/alert/status_effect/buff/TAnoc_bless
	duration = 1 MINUTES

/datum/status_effect/buff/TAnoc_bless/on_creation(mob/living/new_owner, datum/devotion/our_devotion)
	if(GLOB.tod == "day")
		if(our_devotion.level == CLERIC_T4)
			effectedstats = list(STATKEY_STR = 3,STATKEY_CON = 2,STATKEY_SPD = 2)
		else
			effectedstats = list(STATKEY_STR = 2,STATKEY_CON = 2,STATKEY_SPD = 1)
			duration *= 0.75

	else if(GLOB.tod == "dawn")
		if(our_devotion.level == CLERIC_T4)
			effectedstats = list(STATKEY_SPD = 3,STATKEY_PER = 2,STATKEY_LCK = 2)
			duration *= 1.25
		else
			effectedstats = list(STATKEY_SPD = 2,STATKEY_PER = 2,STATKEY_LCK = 1)

	else if(GLOB.tod == "dusk")
		if(our_devotion.level == CLERIC_T4)
			effectedstats = list(STATKEY_WIL = 3,STATKEY_STR = 2,STATKEY_CON = 2)
			duration *= 1.75
		else
			effectedstats = list(STATKEY_WIL = 2,STATKEY_STR = 2,STATKEY_CON = 1)
			duration *= 1.5

	else if(GLOB.tod == "night")
		if(our_devotion.level == CLERIC_T4)
			effectedstats = list(STATKEY_WIL = 3,STATKEY_SPD = 3,STATKEY_PER = 2,STATKEY_LCK = 2)
		else
			effectedstats = list(STATKEY_WIL = 3,STATKEY_SPD = 2,STATKEY_PER = 2,STATKEY_LCK = 1)
		duration *= 2
	. = ..()

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
	invocations = list("Her gaze upon me...!", "I beseech the stars; show me truth!")

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
	if(GLOB.tod == "day")
		to_chat(H, span_warning("ASTRATA IS RISEN! My spell loses some of its potency! (-1 TO STAT BOOST.)"))
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
			int_bonus = assocskill + 1
		duration *= 2
	if(GLOB.tod == "day")
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
			target.energy_add(50 * H.get_skill_level(associated_skill))
			H.energy_add(50 * H.get_skill_level(associated_skill))
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
	desc = "Direct a mote of living darkness to temporarily blind another. \n(-3 PERCEPTION, SHORT BLINDNESS)"
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
		if(!spelltarget.mind)
			spelltarget.Immobilize(5 SECONDS)
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
	Mindless creachers will start to burn. \
	Does not work during dae nor dawn."
	button_icon_state = "moon_light"
	sound = 'sound/magic/churn.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = 2
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR

	secondary_resource_cost = SPELLCOST_MIRACLE

	invocation_type = INVOCATION_SHOUT
	invocations = list("YOUR TRUE FORM REVEALED!!", "THERE IS NO PLACE TO HIDE!!")

	charge_required = TRUE
	charge_time = 3 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 1.5 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/TAmoonscorch/cast(atom/cast_on)
	. = ..()

	if(GLOB.tod == "day")
		to_chat(owner, span_warning("ASTRATA IS RISEN! MY SPELL FIZZLES!"))
		return FALSE
	var/checkrange = (cast_range + owner.get_skill_level(/datum/skill/magic/holy)) //+1 range per holy skill up to a potential of 8.
	for(var/mob/living/M in range(checkrange, owner))
		if(M == owner)
			continue
		var/target_turf = get_turf(M)
		new /obj/effect/temp_visual/TAmoon(target_turf)
		M.apply_status_effect(/datum/status_effect/light_buff/TAmoon, 4)
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
	duration = 15 SECONDS
	color_mob_light = "#3a9399cf"
	outline_colour = "#3a9999cf"

/datum/status_effect/light_buff/TAmoon/on_apply()
	if(!owner.mind) //PVE stuff.
		owner.adjust_fire_stacks(5, /datum/status_effect/fire_handler/fire_stacks/divine)
		owner.ignite_mob()
		owner.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
	return ..()

///////////////////////////
// T3 - Arcyne Affinity. //
///////////////////////////

/datum/action/cooldown/spell/noc/TAspellpack
	name = "Arcyne Affinity"
	desc = "Allows you to learn a set of spells. \n \
	<b>MAGISTER</b>: Greater Arcyne Bolt, Arc Bolt, Gravel Blast, Basic Offensive Magic \n \
	<b>CONTROLLER</b>: Frost Bolt, Geas, Gravity, Wither \n \
	<b>SEER</b>: Attune Hawk, Attune Haste, Fortitude, Arcyne Forge, Mending, Mindlink, Create Campfire"
	button_icon_state = "spellpack"
	click_to_activate = FALSE
	primary_resource_cost = SPELLCOST_MIRACLE
	secondary_resource_cost = SPELLCOST_UTILITY_BUFF
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 5 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	/// var we use to flag we are currently choosing a bundle.
	var/choosing_bundle = FALSE
	var/chosen_bundle
	// Magister - no defense and support, only attacks
	var/list/magister_bundle = list(
		/datum/action/cooldown/spell/projectile/greater_arcyne_bolt,
		/datum/action/cooldown/spell/projectile/arc_bolt,
		/datum/action/cooldown/spell/projectile/spitfire,
		/datum/action/cooldown/spell/projectile/gravel_blast,
		/datum/action/cooldown/spell/projectile/arcyne_lance,
	)
	// Controller - debuffs
	var/list/controller_bundle = list(
		/datum/action/cooldown/spell/projectile/frost_bolt,
		/datum/action/cooldown/spell/geas,
		/datum/action/cooldown/spell/gravity,
		/datum/action/cooldown/spell/wither,
		/datum/action/cooldown/spell/augment_buff/grasp,
	// Seer - support
	)
	var/list/seer_bundle = list(
		/datum/action/cooldown/spell/augment_buff/attune_hawk,
		/datum/action/cooldown/spell/augment_buff/attune_haste,
		/datum/action/cooldown/spell/augment_buff/fortitude,
		/datum/action/cooldown/spell/arcyne_forge,
		/datum/action/cooldown/spell/mending,
		/datum/action/cooldown/spell/mindlink
	)

/datum/action/cooldown/spell/noc/TAspellpack/cast(atom/cast_on)
	. = ..()

	if(choosing_bundle)
		return FALSE
	var/choice = chosen_bundle
	if(!chosen_bundle)
		choosing_bundle = TRUE
		choice = alert(owner, "What type of spells has Noc blessed you with?", "CHOOSE PATH", "Magister", "Controller", "Seer")
		chosen_bundle = choice
		choosing_bundle = FALSE

	switch(choice)
		if("Magister")
			add_spells(owner, magister_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		if("Controller")
			add_spells(owner, controller_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		if("Seer")
			add_spells(owner, seer_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
	return FALSE

/datum/action/cooldown/spell/noc/TAspellpack/proc/add_spells(mob/owner, list/spells, choice_count = 1, grant_all = FALSE)
	for(var/spell_type in spells)
		if(owner?.mind.has_spell(spells[spell_type]))
			spells.Remove(spell_type)
	if(!grant_all)
		var/choice_count_visual = choice_count
		for(var/i in 1 to choice_count)
			var/choice = input(owner, "Choose a spell! Choices remaining: [choice_count_visual]") as null|anything in spells
			if(!isnull(choice))
				var/picked_spell = spells[choice]
				var/datum/new_spell = new picked_spell
				owner?.mind.AddSpell(new_spell)
				choice_count_visual--
				spells.Remove(choice)
	else
		for(var/spell_type in spells)
			var/datum/new_spell = new spell_type
			owner?.mind.AddSpell(new_spell)
	if(!length(spells))
		owner.mind?.RemoveSpell(src.type)

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
