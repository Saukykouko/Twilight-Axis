// Spells
/datum/hag_boon/spell/rat_form
	name = "Boon of rat form"
	desc = "Allows bearer to transform into a small rat...?"
	spell_type = /obj/effect/proc_holder/spell/self/wildshape/hag_rat_form
	points = 30

/obj/effect/proc_holder/spell/self/wildshape/hag_rat_form
	name = "Rat Form"
	desc = "Turns yourself into a small rat!"
	invocation_type = "none"
	recharge_time = 10 SECONDS
	miracle = FALSE
	devotion_cost = 0
	clothes_req = FALSE
	human_req = FALSE
	ignore_cockblock = TRUE

	possible_shapes = list(
		/mob/living/carbon/human/species/wildshape/rat
	)
	disallowed_equipment_type = list(/obj/item/rogueweapon)

/mob/living/carbon/human/species/wildshape/rat
	name = "Rat"
	race = /datum/species/shaperat
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = null
	wildshape_icon = 'icons/roguetown/mob/monster/rat.dmi'
	wildshape_icon_state = "srat"

/mob/living/carbon/human/species/wildshape/rat/gain_inherent_skills()
	. = ..()
	if(mind)
		adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
		adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
		adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
		adjust_skillrank(/datum/skill/misc/sneaking, SKILL_LEVEL_MASTER, TRUE)

		STASTR = 1
		STACON = 1 // YOU GONNA DIE!
		STAWIL = 15
		STAPER = 14
		STASPD = 15
		STAINT = 12

		real_name = "rat"
		faction += "rats"

/datum/species/shaperat
	name = "rat"
	id = "shaperat"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY,
		TRAIT_STEELHEARTED,
		TRAIT_INFINITE_ENERGY,
		TRAIT_ORGAN_EATER,
		TRAIT_WILD_EATER,
		TRAIT_LONGSTRIDER,
		TRAIT_PERFECT_TRACKER,
		TRAIT_DODGEEXPERT,
		TRAIT_CRITICAL_WEAKNESS
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
		)

	languages = list(
		/datum/language/beast,
		/datum/language/common,
	)

/datum/species/shaperat/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), pick('sound/vo/mobs/rat/rat_life.ogg','sound/vo/mobs/rat/rat_life2.ogg','sound/vo/mobs/rat/rat_life3.ogg','sound/vo/mobs/rat/aggro (1).ogg','sound/vo/mobs/rat/aggro (2).ogg', 'sound/vo/mobs/rat/aggro (3).ogg'), 80, TRUE, -1)

/datum/species/shaperat/regenerate_icons(mob/living/carbon/human/human)
	human.icon = 'icons/roguetown/mob/monster/rat.dmi'
	human.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	human.icon_state = "srat"
	human.update_damage_overlays()
	return TRUE

/datum/hag_boon/spell/blesscrop
	name = "Boon of bless crop"
	desc = "Allows bearer to bless crops as druid does."
	spell_type = /obj/effect/proc_holder/spell/targeted/blesscrop
	points = 50

// Curses
/datum/hag_boon/buff/curse/left_eye
	name = "Trait - Scared Left Eye"
	desc = "The bearer's left eye losts it's ability to see."
	points = 65

/datum/hag_boon/buff/curse/left_eye/apply_boon_effect(mob/living/L)
	var/mob/living/carbon/human/H = L
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head?.add_wound(/datum/wound/facial/eyes/left/permanent)
	H.update_fov_angles()

/datum/hag_boon/buff/curse/right_eye
	name = "Trait - Scared Right Eye"
	desc = "The bearer's right eye losts it's ability to see."
	points = 65

/datum/hag_boon/buff/curse/right_eye/apply_boon_effect(mob/living/L)
	var/mob/living/carbon/human/H = L
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head?.add_wound(/datum/wound/facial/eyes/right/permanent)
	H.update_fov_angles()

/datum/hag_boon/trait/curse/vegan
	name = "Trait - Vegan"
	trait_to_apply = TRAIT_VEGAN
	desc = "The bearer becomes Vegan... What a awful fate!"
	points = 15

/datum/hag_boon/trait/curse/light_sensivity
	name = "Trait - Light Sensivity"
	trait_to_apply = TRAIT_SUNLIGHT_SENSITIVE
	desc = "The bearer eyes becomes really sensitive to light!"
	points = 65

// Traits
/datum/hag_boon/trait/parry_expert
	name = "Trait - Parry Expert"
	trait_to_apply = TRAIT_PARRYEXPERT
	desc = "Enhances the bearer's abiliy to parry with weapon."
	points = 40

/datum/hag_boon/trait/poison_immune
	name = "Trait - Poison Immune"
	trait_to_apply = TRAIT_TOXIMMUNE
	desc = "Grants the snake constitution, that allows to endure any poison."
	points = 30

/datum/hag_boon/trait/eoran_serene
	name = "Trait - No Stress"
	trait_to_apply = TRAIT_EORAN_SERENE
	desc = "Grants the bearer the blessing of Eora, removing any stress."
	points = 40

/datum/hag_boon/trait/light_step
	name = "Trait - Light Steps"
	trait_to_apply = TRAIT_LIGHT_STEP
	desc = "Bearer steps more lighty and swifty, makes less noise when walking and can sneak much quicker."
	points = 30

/datum/hag_boon/trait/noble
	name = "Trait - Noble"
	trait_to_apply = TRAIT_NOBLE
	desc = "Bearer becomes noble!"
	points = 65

// Other

/datum/hag_boon/buff/devotee
	name = "Devotee"
	desc = "Bearer gain the lesserest miracles of their god, but if they already has it, their devotee regeneration will be increased..."
	points = 50

/datum/hag_boon/buff/devotee/apply_boon_effect(mob/living/L)
	var/mob/living/carbon/human/H = L
	H.adjust_skillrank_up_to(/datum/skill/magic/holy, 4, TRUE)
	if(!H.devotion)
		var/datum/devotion/new_faith = new /datum/devotion(H, H.patron)
		new_faith.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = (CLERIC_REQ_1))
	else
		var/datum/devotion/our_faith = H.devotion
		our_faith.passive_devotion_gain += CLERIC_REGEN_WEAK
		START_PROCESSING(SSobj, our_faith)
	return

/datum/hag_boon/buff/arcyne_affinity
	name = "Arcyne Affinity"
	desc = "Bearer gain the arcyne potencial and learn some spells!"
	points = 65

/datum/hag_boon/buff/arcyne_affinity/apply_boon_effect(mob/living/L)
	var/mob/living/carbon/human/H = L
	if (!H.get_skill_level(/datum/skill/magic/arcane))
		if (!H.mind?.has_spell(/datum/action/cooldown/spell/touch/prestidigitation))
			H.mind?.AddSpell(new /datum/action/cooldown/spell/touch/prestidigitation)
			ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
			if(!LAZYLEN(H.mind.mage_aspect_config))
				H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 3), grant_attunement = FALSE)
			H.mind.check_learnspell()
	else
		H.mind.mage_aspect_config["minor"] += 1
		H.mind.mage_aspect_config["utilities"] += 3
		H.mind.check_learnspell()
	H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 4, TRUE)
	return

/datum/hag_boon/buff/arcyne_affinity/proc/add_arcyne_potential_utilities(mob/living/carbon/human/H, amount)
	if(!H.mind)
		return
	if(!LAZYLEN(H.mind.mage_aspect_config))
		H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 3), grant_attunement = FALSE)
	H.mind.mage_aspect_config["utilities"] += amount
	H.mind.check_learnspell()

/datum/hag_boon/buff/skeleton
	name = "Skeleton Form"
	desc = "Bearer becomes a Skeleton, nothing else."
	points = 100

/datum/hag_boon/buff/skeleton/apply_boon_effect(mob/living/L)
	var/mob/living/carbon/human/H = L
	H.become_skeleton()
	H.select_skeleton_features()
	return

/datum/hag_boon/rejuvenate
	name = "Wyrd Rejuvenation"
	desc = "Cures all long-term physical ailments, including: blindness, ugliness, missing limbs, and leprosy. Does not heal immediate wounds such as fractures and bleeds, and will not fix divine curses such as lux-taint, silver-weakness, vampirisim, or lycanthropy."
	points = 50

/datum/hag_boon/rejuvenate/apply_boon_effect(mob/living/L)
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	H.visible_message(span_warning("[H] stands, wreathed in a strange energy as [H.p_their()] body restores itself!"), span_green("I feel the burdens of the flesh lift from me!"))
	H.SetUnconscious(0) // this is all copied from the surge spell. it's just for aura, and shouldn't have any real effect
	H.SetSleeping(0)
	H.SetParalyzed(0)
	H.SetImmobilized(0)
	H.SetStun(0)
	H.SetKnockdown(0)
	if(H.has_status_effect(/datum/status_effect/incapacitating/off_balanced))
		H.remove_status_effect(/datum/status_effect/incapacitating/off_balanced)
	H.stam_paralyzed = FALSE
	H.set_resting(FALSE)
	H.rest_locked_until = world.time + 1 SECONDS

	var/list/blindness_flaws = list()
	var/datum/charflaw/leprosy/leper
	for(var/datum/charflaw/cf in H.charflaws)
		if(istype(cf, /datum/charflaw/noeyeall))
			H.clear_fullscreen("blind_flaw")
			REMOVE_TRAIT(H, TRAIT_NITEVISION, TRAIT_GENERIC)
			H.update_sight()
			blindness_flaws += cf
		if(istype(cf, /datum/charflaw/noeyel))
			var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
			if(!head && H.dna?.species && istype(H.dna.species, /datum/species/dullahan))
				var/datum/species/dullahan/rev = H.dna.species
				if(rev.headless) // that'd explain it. attach their head before we proceed
					rev.my_head.attach_limb(H)
					H.update_a_intents()
					var/obj/item/organ/dullahan_vision/vision = H.getorganslot(ORGAN_SLOT_HUD)
					vision.viewing_head = FALSE
					H.reset_perspective()
					head = H.get_bodypart(BODY_ZONE_HEAD)
			if(!head)
				continue
			head.remove_wound(/datum/wound/facial/eyes/left/permanent)
			H.update_fov_angles()
			blindness_flaws += cf
		if(istype(cf, /datum/charflaw/noeyer))
			var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
			if(!head && H.dna?.species && istype(H.dna.species, /datum/species/dullahan))
				var/datum/species/dullahan/rev = H.dna.species
				if(rev.headless)
					rev.my_head.attach_limb(H)
					H.update_a_intents()
					var/obj/item/organ/dullahan_vision/vision = H.getorganslot(ORGAN_SLOT_HUD)
					vision.viewing_head = FALSE
					H.reset_perspective()
					head = H.get_bodypart(BODY_ZONE_HEAD)
			if(!head)
				continue
			head.remove_wound(/datum/wound/facial/eyes/right/permanent)
			H.update_fov_angles()
			blindness_flaws += cf
		if(istype(cf, /datum/charflaw/colorblind))
			H.remove_client_colour(/datum/client_colour/monochrome)
			blindness_flaws += cf
		if(istype(cf, /datum/charflaw/leprosy))
			leper = cf
	if(length(blindness_flaws))
		to_chat(H, span_smallgreen("Light floods my senses as my sight is restored!"))
		for(var/datum/charflaw/cf in blindness_flaws)
			H.charflaws.Remove(cf)
			qdel(cf)
	if(leper)
		REMOVE_TRAIT(H, TRAIT_LEPROSY, TRAIT_GENERIC)
		H.change_stat(STATKEY_STR, 1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 1)
		H.change_stat(STATKEY_CON, 1)
		H.change_stat(STATKEY_WIL, 1)
		H.change_stat(STATKEY_SPD, 1)
		H.change_stat(STATKEY_LCK, 1)
		to_chat(H, span_smallgreen("My constitution bolsters as my illness vanishes!"))
		H.charflaws.Remove(leper)
		QDEL_NULL(leper)
	var/list/regenerable_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_TAUR)
	for(var/obj/item/bodypart/BP in H.bodyparts)
		if(BP.is_prosthetic_limb())
			BP.dismember(skip_checks = TRUE)
	var/missing_limbs = H.get_missing_limbs()
	for(var/limb_zone in missing_limbs)
		if(limb_zone in regenerable_zones)
			H.regenerate_limb(limb_zone)
			H.visible_message(span_warning("[H]'s [limb_zone] rapidly regrows!"), span_smallgreen("I feel a terrible itching sensation as my [limb_zone] regrows!"))
	if(HAS_TRAIT(H, TRAIT_UNSEEMLY))
		REMOVE_TRAIT(H, TRAIT_UNSEEMLY, null)
		to_chat(H, span_smallgreen("My posture straigtens, my face is mended; my disfigurement is lifted!"))
	clean_body_parts(H)
	return

// Crafts
/datum/crafting_recipe/roguetown/alchemy/hag/vibrant_moss
	name = "moss vibrant"
	result = list(/obj/item/alch/hag_moss/enchanted/vibrant = 1)
	reqs = list(/obj/item/alch/hag_moss/mercy = 1, /obj/item/alch/rosa = 1, /obj/item/alch/hypericum = 1)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/boned_moss
	name = "moss boned"
	result = list(/obj/item/alch/hag_moss/enchanted/boned = 1)
	reqs = list(/obj/item/alch/hag_moss/envy = 1, /obj/item/natural/bone = 2)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/altered_moss
	name = "moss altered"
	result = list(/obj/item/alch/hag_moss/enchanted/altered = 1)
	reqs = list(/obj/item/alch/hag_moss/sorrow = 1, /obj/item/reagent_containers/food/snacks/rogue/meat/rat = 1)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/forest_moss
	name = "moss forest"
	result = list(/obj/item/alch/hag_moss/enchanted/forest = 1)
	reqs = list(/obj/item/alch/hag_moss/mercy = 1, /obj/item/alch/mentha = 1, /obj/item/alch/rosa = 1)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/night_moss
	name = "moss nighty"
	result = list(/obj/item/alch/hag_moss/enchanted/magical = 1)
	reqs = list(/obj/item/alch/hag_moss/lullaby = 1, /obj/item/alch/manabloompowder = 1)
	craftdiff = 6

// Moss
/obj/item/alch/hag_moss/enchanted/vibrant
	name = "Vibrant Moss"
	boon_path = /datum/hag_boon/rejuvenate
	desc = "This moss is overly-bright, overflowing with energy."
	color = "#00ff00" // oversaturated on purpose

/obj/item/alch/hag_moss/enchanted/boned
	name = "Boned Moss"
	boon_path = /datum/hag_boon/buff/skeleton
	desc = "This moss is grey. Smells and feels like bones."
	color = "#596d7a"

/obj/item/alch/hag_moss/enchanted/altered
	name = "Altered Moss"
	boon_path = /datum/hag_boon/spell/rat_form
	desc = "This moss is dark-brown, and smells like... Ew-w... That's DISGUSTING!!!"
	color = "#534734"

/obj/item/alch/hag_moss/enchanted/forest
	name = "Forest Moss"
	boon_path = /datum/hag_boon/spell/blesscrop
	desc = "This moss is brown, touching it feels so fruitful!"
	color = "#9e7b43"

/obj/item/alch/hag_moss/enchanted/magical
	name = "Night Moss"
	boon_path = /datum/hag_boon/buff/arcyne_affinity
	desc = "This moss is strange, touching it makes you feel closer to arcyne and the devotee..."
	color = "#43589e"

/obj/item/alch/hag_moss/enchanted/magical/Initialize(mapload)
	. = ..()
	if(prob(50))
		boon_path = /datum/hag_boon/buff/devotee
		name = "Devotee Moss"
	else
		boon_path = /datum/hag_boon/buff/arcyne_affinity
		name = "Arcyne Moss"
