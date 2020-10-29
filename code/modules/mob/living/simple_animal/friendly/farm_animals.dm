//goat
/mob/living/simple_animal/hostile/retaliate/goat
	name = "goat"
	desc = "Not known for their pleasant disposition."
	icon_state = "goat"
	icon_living = "goat"
	icon_dead = "goat_dead"
	speak = list("EHEHEHEHEH","eh?")
	speak_emote = list("brays")
	emote_hear = list("brays.")
	emote_see = list("shakes its head.", "stamps a foot.", "glares around.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 4)
	response_help_continuous  = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	faction = list("neutral")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	attack_same = 1
	attack_verb_continuous = "kicks"
	attack_verb_simple = "kick"
	attack_sound = 'sound/weapons/punch1.ogg'
	health = 40
	maxHealth = 40
	melee_damage_lower = 1
	melee_damage_upper = 2
	environment_smash = ENVIRONMENT_SMASH_NONE
	stop_automated_movement_when_pulled = 1
	blood_volume = BLOOD_VOLUME_NORMAL
	var/obj/item/udder/udder = null
	var/datum/reagent/milk_reagent = /datum/reagent/consumable/milk

	footstep_type = FOOTSTEP_MOB_SHOE

/mob/living/simple_animal/hostile/retaliate/goat/Initialize(/datum/reagent/milk_reagent)
	udder = new (null, milk_reagent)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/goat/Destroy()
	qdel(udder)
	udder = null
	return ..()

/mob/living/simple_animal/hostile/retaliate/goat/BiologicalLife(seconds, times_fired)
	if(!(. = ..()))
		return
	if(stat == CONSCIOUS)
		//chance to go crazy and start wacking stuff
		if(!enemies.len && prob(1))
			Retaliate()

		if(enemies.len && prob(10))
			enemies = list()
			LoseTarget()
			src.visible_message("<span class='notice'>[src] calms down.</span>")
		udder.generateMilk(milk_reagent)
		eat_plants()
		if(!pulledby)
			for(var/direction in shuffle(list(1,2,4,8,5,6,9,10)))
				var/step = get_step(src, direction)
				if(step)
					if(locate(/obj/structure/spacevine) in step || locate(/obj/structure/glowshroom) in step)
						Move(step, get_dir(src, step))

/mob/living/simple_animal/hostile/retaliate/goat/Retaliate()
	..()
	src.visible_message("<span class='danger'>[src] gets an evil-looking gleam in [p_their()] eye.</span>")

/mob/living/simple_animal/hostile/retaliate/goat/Move()
	. = ..()
	if(!stat)
		eat_plants()

/mob/living/simple_animal/hostile/retaliate/goat/proc/eat_plants()
	var/eaten = FALSE
	var/obj/structure/spacevine/SV = locate(/obj/structure/spacevine) in loc
	if(SV)
		SV.eat(src)
		eaten = TRUE

	var/obj/structure/glowshroom/GS = locate(/obj/structure/glowshroom) in loc
	if(GS)
		qdel(GS)
		eaten = TRUE

	if(eaten && prob(10))
		say("Nom")

/mob/living/simple_animal/hostile/retaliate/goat/attackby(obj/item/O, mob/user, params)
	if(stat == CONSCIOUS && istype(O, /obj/item/reagent_containers/glass))
		udder.milkAnimal(O, user)
		return 1
	else
		return ..()


/mob/living/simple_animal/hostile/retaliate/goat/AttackingTarget()
	. = ..()
	if(. && ishuman(target))
		var/mob/living/carbon/human/H = target
		if(istype(H.dna.species, /datum/species/pod))
			var/obj/item/bodypart/NB = pick(H.bodyparts)
			H.visible_message("<span class='warning'>[src] takes a big chomp out of [H]!</span>", \
								  "<span class='userdanger'>[src] takes a big chomp out of your [NB]!</span>")
			NB.dismember()
//cow
/mob/living/simple_animal/cow
	name = "cow"
	desc = "Known for their milk, just don't tip them over."
	icon_state = "cow"
	icon_living = "cow"
	icon_dead = "cow_dead"
	icon_gib = "cow_gib"
	gender = FEMALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak = list("moo?","moo","MOOOOOO")
	speak_emote = list("moos","moos hauntingly")
	emote_hear = list("brays.")
	emote_see = list("shakes its head.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 6)
	response_help_continuous  = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	attack_verb_continuous = "kicks"
	attack_verb_simple = "kick"
	attack_sound = 'sound/weapons/punch1.ogg'
	health = 50
	maxHealth = 50
	var/obj/item/udder/udder = null
	var/datum/reagent/milk_reagent = /datum/reagent/consumable/milk
	gold_core_spawnable = FRIENDLY_SPAWN
	var/is_calf = 0
	var/has_calf = 0
//	var/young_type = /mob/living/simple_animal/cow/calf
	blood_volume = BLOOD_VOLUME_NORMAL

	footstep_type = FOOTSTEP_MOB_SHOE

/mob/living/simple_animal/cow/Initialize()
	udder = new(null, milk_reagent)
	. = ..()

/mob/living/simple_animal/cow/Destroy()
	qdel(udder)
	udder = null
	return ..()

/mob/living/simple_animal/cow/attackby(obj/item/O, mob/user, params)
	if(stat == CONSCIOUS && istype(O, /obj/item/reagent_containers/glass))
		udder.milkAnimal(O, user)
		return 1
	else
		return ..()

/mob/living/simple_animal/cow/BiologicalLife(seconds, times_fired)
	if(!(. = ..()))
		return
	if(stat == CONSCIOUS)
		udder.generateMilk(milk_reagent)

/mob/living/simple_animal/cow/on_attack_hand(mob/living/carbon/M)
	if(!stat && M.a_intent == INTENT_DISARM && icon_state != icon_dead)
		M.visible_message("<span class='warning'>[M] tips over [src].</span>",
			"<span class='notice'>You tip over [src].</span>")
		to_chat(src, "<span class='userdanger'>You are tipped over by [M]!</span>")
		DefaultCombatKnockdown(60,ignore_canknockdown = TRUE)
		icon_state = icon_dead
		spawn(rand(20,50))
			if(!stat && M)
				icon_state = icon_living
				var/external
				var/internal
				switch(pick(1,2,3,4))
					if(1,2,3)
						var/text = pick("imploringly.", "pleadingly.",
							"with a resigned expression.")
						external = "[src] looks at [M] [text]"
						internal = "You look at [M] [text]"
					if(4)
						external = "[src] seems resigned to its fate."
						internal = "You resign yourself to your fate."
				visible_message("<span class='notice'>[external]</span>",
					"<span class='revennotice'>[internal]</span>")
	else
		..()

//a cow that produces a random reagent in its udder
/mob/living/simple_animal/cow/random
	name = "strange cow"
	desc = "Something seems off about the milk this cow is producing."

/mob/living/simple_animal/cow/random/Initialize()
	milk_reagent = get_random_reagent_id() //this has a blacklist so don't worry about romerol cows, etc
	..()

//Wisdom cow, speaks and bestows great wisdoms
/mob/living/simple_animal/cow/wisdom
	name = "wisdom cow"
	desc = "Known for its wisdom, shares it with all"
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab/wisdomcow = 1) //truly the best meat
	gold_core_spawnable = FALSE
	speak_chance = 10 //the cow is eager to share its wisdom! //but is wise enough to not lag  the server too bad
	milk_reagent = /datum/reagent/medicine/liquid_wisdom

/mob/living/simple_animal/cow/wisdom/Initialize()
	. = ..()
	speak = GLOB.wisdoms //Done here so it's setup properly

/mob/living/simple_animal/chick
	name = "\improper chick"
	desc = "Adorable! They make such a racket though."
	icon_state = "chick"
	icon_living = "chick"
	icon_dead = "chick_dead"
	icon_gib = "chick_gib"
	gender = FEMALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak = list("Cherp.","Cherp?","Chirrup.","Cheep!")
	speak_emote = list("cheeps")
	emote_hear = list("cheeps.")
	emote_see = list("pecks at the ground.","flaps its tiny wings.")
	density = FALSE
	speak_chance = 2
	turns_per_move = 2
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab/chicken = 1)
	response_help_continuous  = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	attack_verb_continuous = "kicks"
	attack_verb_simple = "kick"
	health = 3
	maxHealth = 3
	ventcrawler = VENTCRAWLER_ALWAYS
	var/amount_grown = 0
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	gold_core_spawnable = FRIENDLY_SPAWN

	footstep_type = FOOTSTEP_MOB_CLAW

/mob/living/simple_animal/chick/Initialize()
	. = ..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)

/mob/living/simple_animal/chick/BiologicalLife(seconds, times_fired)
	if(!(. = ..()))
		return
	if(!stat && !ckey)
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			new /mob/living/simple_animal/chicken(src.loc)
			qdel(src)

/mob/living/simple_animal/chick/holo/BiologicalLife(seconds, times_fired)
	if(!(. = ..()))
		return
	amount_grown = 0

/mob/living/simple_animal/chicken
	name = "\improper chicken"
	desc = "Hopefully the eggs are good this season."
	gender = FEMALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	icon_state = "chicken_brown"
	icon_living = "chicken_brown"
	icon_dead = "chicken_brown_dead"
	speak = list("Cluck!","BWAAAAARK BWAK BWAK BWAK!","Bwaak bwak.")
	speak_emote = list("clucks","croons")
	emote_hear = list("clucks.")
	emote_see = list("pecks at the ground.","flaps its wings viciously.")
	density = FALSE
	speak_chance = 2
	turns_per_move = 3
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab/chicken = 2)
	var/egg_type = /obj/item/reagent_containers/food/snacks/egg
	var/food_type = /obj/item/reagent_containers/food/snacks/grown/wheat
	response_help_continuous  = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	attack_verb_continuous = "kicks"
	attack_verb_simple = "kick"
	health = 15
	maxHealth = 15
	ventcrawler = VENTCRAWLER_ALWAYS
	var/eggsleft = 0
	var/eggsFertile = TRUE
	var/body_color
	var/icon_prefix = "chicken"
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	var/list/feedMessages = list("It clucks happily.","It clucks happily.")
	var/list/layMessage = EGG_LAYING_MESSAGES
	var/list/validColors = list("brown","black","white")
	gold_core_spawnable = FRIENDLY_SPAWN
	var/static/chicken_count = 0

	footstep_type = FOOTSTEP_MOB_CLAW

/mob/living/simple_animal/chicken/Initialize()
	. = ..()
	if(!body_color)
		body_color = pick(validColors)
	icon_state = "[icon_prefix]_[body_color]"
	icon_living = "[icon_prefix]_[body_color]"
	icon_dead = "[icon_prefix]_[body_color]_dead"
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)
	++chicken_count

/mob/living/simple_animal/chicken/Destroy()
	--chicken_count
	return ..()

/mob/living/simple_animal/chicken/attackby(obj/item/O, mob/user, params)
	if(istype(O, food_type)) //feedin' dem chickens
		if(!stat && eggsleft < 8)
			var/feedmsg = "[user] feeds [O] to [name]! [pick(feedMessages)]"
			user.visible_message(feedmsg)
			qdel(O)
			eggsleft += rand(1, 4)
		else
			to_chat(user, "<span class='warning'>[name] doesn't seem hungry!</span>")
	else
		..()

/mob/living/simple_animal/chicken/BiologicalLife(seconds, times_fired)
	if(!(. = ..()))
		return
	if((!stat && prob(3) && eggsleft > 0) && egg_type)
		visible_message("<span class='alertalien'>[src] [pick(layMessage)]</span>")
		eggsleft--
		var/obj/item/E = new egg_type(get_turf(src))
		E.pixel_x = rand(-6,6)
		E.pixel_y = rand(-6,6)
		if(eggsFertile)
			if(chicken_count < MAX_CHICKENS && prob(25))
				START_PROCESSING(SSobj, E)

/obj/item/reagent_containers/food/snacks/egg/var/amount_grown = 0
/obj/item/reagent_containers/food/snacks/egg/process()
	if(isturf(loc))
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			visible_message("[src] hatches with a quiet cracking sound.")
			new /mob/living/simple_animal/chick(get_turf(src))
			STOP_PROCESSING(SSobj, src)
			qdel(src)
	else
		STOP_PROCESSING(SSobj, src)

// Space kiwis, ergo quite a copypasta of chickens.

/mob/living/simple_animal/kiwi
	name = "space kiwi"
	desc = "Exposure to low gravity made them grow larger."
	gender = FEMALE
	icon_state = "kiwi"
	icon_living = "kiwi"
	icon_dead = "kiwi_dead"
	speak = list("Chirp!","Cheep cheep chirp!!","Cheep.")
	speak_emote = list("chirps","trills")
	emote_hear = list("chirps.")
	emote_see = list("pecks at the ground.","jumps in place.")
	density = FALSE
	speak_chance = 2
	turns_per_move = 3
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 3)
	var/egg_type = /obj/item/reagent_containers/food/snacks/egg/kiwiEgg
	var/food_type = /obj/item/reagent_containers/food/snacks/grown/wheat
	response_help_continuous  = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	attack_verb_continuous = "kicks"
	attack_verb_simple = "kick"
	health = 25
	maxHealth = 25
	ventcrawler = VENTCRAWLER_ALWAYS
	var/eggsleft = 0
	var/eggsFertile = TRUE
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	var/list/feedMessages = list("It chirps happily.","It chirps happily.")
	var/list/layMessage = list("lays an egg.","squats down and croons.","begins making a huge racket.","begins chirping raucously.")
	gold_core_spawnable = FRIENDLY_SPAWN
	var/static/kiwi_count = 0

	footstep_type = FOOTSTEP_MOB_CLAW

/mob/living/simple_animal/kiwi/Destroy()
	--kiwi_count
	return ..()

/mob/living/simple_animal/kiwi/Initialize()
	. = ..()
	++kiwi_count

/mob/living/simple_animal/kiwi/BiologicalLife(seconds, times_fired)
	if(!(. = ..()))
		return
	if((!stat && prob(3) && eggsleft > 0) && egg_type)
		visible_message("[src] [pick(layMessage)]")
		eggsleft--
		var/obj/item/E = new egg_type(get_turf(src))
		E.pixel_x = rand(-6,6)
		E.pixel_y = rand(-6,6)
		if(eggsFertile)
			if(kiwi_count < MAX_CHICKENS && prob(25))
				START_PROCESSING(SSobj, E)

/obj/item/reagent_containers/food/snacks/egg/kiwiEgg/process()
	if(isturf(loc))
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			visible_message("[src] hatches with a quiet cracking sound.")
			new /mob/living/simple_animal/babyKiwi(get_turf(src))
			STOP_PROCESSING(SSobj, src)
			qdel(src)
	else
		STOP_PROCESSING(SSobj, src)

/mob/living/simple_animal/kiwi/attackby(obj/item/O, mob/user, params)
	if(istype(O, food_type)) //feedin' dem kiwis
		if(!stat && eggsleft < 8)
			var/feedmsg = "[user] feeds [O] to [name]! [pick(feedMessages)]"
			user.visible_message(feedmsg)
			qdel(O)
			eggsleft += rand(1, 4)
		else
			to_chat(user, "<span class='warning'>[name] doesn't seem hungry!</span>")
	else
		..()

/mob/living/simple_animal/babyKiwi
	name = "baby space kiwi"
	desc = "So huggable."
	icon_state = "babykiwi"
	icon_living = "babykiwi"
	icon_dead = "babykiwi_dead"
	gender = FEMALE
	speak = list("Cherp.","Cherp?","Chirrup.","Cheep!")
	speak_emote = list("chirps")
	emote_hear = list("chirps.")
	emote_see = list("pecks at the ground.","Happily bounces in place.")
	density = FALSE
	speak_chance = 2
	turns_per_move = 2
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 2)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	attack_verb_continuous = "kicks"
	attack_verb_simple = "kick"
	health = 10
	maxHealth = 10
	ventcrawler = VENTCRAWLER_ALWAYS
	var/amount_grown = 0
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	gold_core_spawnable = FRIENDLY_SPAWN

	footstep_type = FOOTSTEP_MOB_CLAW

/mob/living/simple_animal/babyKiwi/Initialize()
	. = ..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)

/mob/living/simple_animal/babyKiwi/BiologicalLife(seconds, times_fired)
	if(!(. = ..()))
		return
	if(!stat && !ckey)
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			new /mob/living/simple_animal/kiwi(src.loc)
			qdel(src)

/obj/item/reagent_containers/food/snacks/egg/kiwiEgg
	name = "kiwi egg"
	desc = "A slightly bigger egg!"
	icon_state = "kiwiegg"

/obj/item/udder
	name = "udder"

/obj/item/udder/Initialize(loc, milk_reagent)
	if(!milk_reagent)
		milk_reagent = /datum/reagent/consumable/milk
	create_reagents(50, NONE, NO_REAGENTS_VALUE)
	reagents.add_reagent(milk_reagent, 20)
	. = ..()

/obj/item/udder/proc/generateMilk(datum/reagent/milk_reagent)
	if(prob(5))
		reagents.add_reagent(milk_reagent, rand(5, 10))

/obj/item/udder/proc/milkAnimal(obj/O, mob/user)
	var/obj/item/reagent_containers/glass/G = O
	if(G.reagents.total_volume >= G.volume)
		to_chat(user, "<span class='danger'>[O] is full.</span>")
		return
	var/transfered = reagents.trans_to(O, rand(5,10))
	if(transfered)
		user.visible_message("[user] milks [src] using \the [O].", "<span class='notice'>You milk [src] using \the [O].</span>")
	else
		to_chat(user, "<span class='danger'>The udder is dry. Wait a bit longer...</span>")

/mob/living/simple_animal/deer
	name = "doe"
	desc = "A gentle, peaceful forest animal. How did this get into space?"
	icon_state = "deer-doe"
	icon_living = "deer-doe"
	icon_dead = "deer-doe-dead"
	gender = FEMALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak = list("Weeeeeeee?","Weeee","WEOOOOOOOOOO")
	speak_emote = list("grunts","grunts lowly")
	emote_hear = list("brays.")
	emote_see = list("shakes its head.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 3)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently nudges"
	response_disarm_simple = "gently nudge"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	attack_verb_continuous = "bucks"
	attack_verb_simple = "buck"
	attack_sound = 'sound/weapons/punch1.ogg'
	health = 75
	maxHealth = 75
	blood_volume = BLOOD_VOLUME_NORMAL
	footstep_type = FOOTSTEP_MOB_SHOE

/mob/living/simple_animal/cow/brahmin
	name = "brahmin"
	desc = "Brahmin or brahma are mutated cattle with two heads and looking udderly ridiculous.<br>Known for their milk, just don't tip them over."
	icon = 'icons/mob/wastemobs.dmi'
	icon_state = "brahmin"
	icon_living = "brahmin"
	icon_dead = "brahmin_dead"
	icon_gib = "brahmin_gib"
	speak = list("Moo?","Moo!","Mooo!","Moooo!","Moooo.")
	var/young_type = /mob/living/simple_animal/cow/brahmin/calf
	emote_hear = list("brays.")
	var/obj/item/inventory_back
	speak_chance = 0.4
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 4, /obj/item/reagent_containers/food/snacks/rawbrahminliver = 1, /obj/item/reagent_containers/food/snacks/rawbrahmintongue = 2, /obj/item/stack/sheet/animalhide/brahmin = 3)


/mob/living/simple_animal/cow/brahmin/calf
	name = "brahmin calf"
	is_calf = 1

/mob/living/simple_animal/cow/brahmin/calf/Initialize()
	. = ..()
	resize = 0.7
	update_transform()

//////
//Tangle of mess for brahmin packs
//////
/*
/mob/living/simple_animal/cow/brahmin/show_inv(mob/user)
	user.set_machine(src)
	if(user.stat)
		return

	var/dat = 	"<div align='center'><b>Inventory of [name]</b></div><p>"
	if(inventory_back)
		dat +=	"<br><b>Back:</b> [inventory_back] (<a href='?src=[REF(src)];remove_inv=back'>Remove</a>)"
	else
		dat +=	"<br><b>Back:</b> <a href='?src=[REF(src)];add_inv=back'>Nothing</a>"

	user << browse(dat, text("window=mob[];size=325x500", real_name))
	onclose(user, "mob[real_name]")
	return

mob/living/simple_animal/cow/brahmin/Topic(href, href_list)
	if(usr.stat)
		return

	//Removing from inventory
	if(href_list["remove_inv"])
		if(!Adjacent(usr) || !(ishuman(usr) || ismonkey(usr) || iscyborg(usr) ||  isalienadult(usr)))
			return
		var/remove_from = href_list["remove_inv"]
		switch(remove_from)
			if("back")
				if(inventory_back)
					inventory_back.forceMove(drop_location())
					inventory_back = null
					update_brahmin_fluff()
					regenerate_icons()
				else
					to_chat(usr, "<span class='danger'>There is nothing to remove from its [remove_from].</span>")
					return

		show_inv(usr)

	//Adding things to inventory
	else if(href_list["add_inv"])
		if(!Adjacent(usr) || !(ishuman(usr) || ismonkey(usr) || iscyborg(usr) ||  isalienadult(usr)))
			return

		var/add_to = href_list["add_inv"]

		switch(add_to)

			if("back")
				if(inventory_back)
					to_chat(usr, "<span class='warning'>It's already wearing something!</span>")
					return
				else
					var/obj/item/item_to_add = usr.get_active_held_item()

					if(!item_to_add)
						usr.visible_message("[usr] pets [src].","<span class='notice'>You rest your hand on [src]'s back for a moment.</span>")
						return

					if(!usr.temporarilyRemoveItemFromInventory(item_to_add))
						to_chat(usr, "<span class='warning'>\The [item_to_add] is stuck to your hand, you cannot put it on [src]'s back!</span>")
						return

					//The objects that brahmin can wear on their backs.
					var/allowed = FALSE
					if(ispath(item_to_add.brahmin_fashion, /datum/brahmin_fashion/back))
						allowed = TRUE

					if(!allowed)
						to_chat(usr, "<span class='warning'>You set [item_to_add] on [src]'s back, but it falls off!</span>")
						item_to_add.forceMove(drop_location())
						if(prob(25))
							step_rand(item_to_add)
						for(var/i in list(1,2,4,8,4,8,4,dir))
							setDir(i)
							sleep(1)
						return

					item_to_add.forceMove(src)
					src.inventory_back = item_to_add
					update_brahmin_fluff()
					regenerate_icons()

		show_inv(usr)
	else
		..()
*/

/mob/living/simple_animal/cow/brahmin/proc/update_brahmin_fluff() //none of this should do anything for now, but it may be used for updating sprites later
	// First, change back to defaults
	name = real_name
	desc = initial(desc)
	// BYOND/DM doesn't support the use of initial on lists.
	speak = list("Moo?","Moo!","Mooo!","Moooo!","Moooo.")
	emote_hear = list("brays.")
	desc = initial(desc)
	set_light(0)
/*
	if(inventory_back && inventory_back.brahmin_fashion)
		var/datum/brahmin_fashion/BF = new inventory_back.brahmin_fashion(src)
		BF.apply(src)

/mob/living/simple_animal/cow/brahmin/regenerate_icons()
	..()
	if(inventory_back)
		var/image/back_icon
		var/datum/brahmin_fashion/BF = new inventory_back.brahmin_fashion(src)

		if(!BF.obj_icon_state)
			BF.obj_icon_state = inventory_back.icon_state
		if(!BF.obj_alpha)
			BF.obj_alpha = inventory_back.alpha
		if(!BF.obj_color)
			BF.obj_color = inventory_back.color

		if(health <= 0)
			back_icon = BF.get_overlay(dir = EAST)
			back_icon.pixel_y = -11
			back_icon.transform = turn(back_icon.transform, 180)
		else
			back_icon = BF.get_overlay()
		add_overlay(back_icon)

	return
*/
/mob/living/simple_animal/radstag
	name = "radstag"
	desc = "a two headed dear that will run at the first sight of danger."
	icon = 'icons/mob/wastemobs.dmi'
	icon_state = "radstag"
	icon_living = "radstag"
	icon_dead = "radstag_dead"
	icon_gib = "radstag_gib"
	gender = FEMALE
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 6, /obj/item/stack/sheet/sinew = 2, /obj/item/stack/sheet/animalhide/ragstag = 2)
	response_help_simple  = "pets"
	response_disarm_simple = "gently pushes aside"
	response_harm_simple   = "kicks"
	attack_verb_simple = "kicks"
	attack_sound = 'sound/weapons/punch1.ogg'
	health = 50
	maxHealth = 50
	gold_core_spawnable = FRIENDLY_SPAWN
	blood_volume = BLOOD_VOLUME_NORMAL
	faction = list("neutral")

/mob/living/simple_animal/hostile/retaliate/goat/bighorn
	name = "big horner"
	desc = "Mutated bighorn sheep that are often found in mountains, and are known for being foul-tempered even at the best of times."
	icon = 'icons/mob/wastemobs.dmi'
	icon_state = "bighorner"
	icon_living = "bighorner"
	icon_dead = "bighorner_dead"
	icon_gib = "bighorner_gib"
	speak = list("EHEHEHEHEH","eh?")
	speak_emote = list("brays")
	emote_hear = list("brays.")
	emote_see = list("shakes its head.", "stamps a foot.", "glares around.", "grunts.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 6, /obj/item/stack/sheet/sinew = 3, /obj/item/stack/sheet/bone = 4)
	response_help_simple  = "pets"
	response_disarm_simple = "gently pushes aside"
	response_harm_simple   = "kicks"
	faction = list("neutral", "bighorner")
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	attack_verb_simple = "rams"
	attack_sound = 'sound/weapons/punch1.ogg'
	health = 120
	maxHealth = 120
	melee_damage_lower = 25
	melee_damage_upper = 20
	environment_smash = ENVIRONMENT_SMASH_NONE
	stop_automated_movement_when_pulled = 1
	blood_volume = BLOOD_VOLUME_NORMAL
	var/is_calf = 0
	var/food_type = /obj/item/reagent_containers/food/snacks/grown/wheat
	var/has_calf = 0
	var/young_type = /mob/living/simple_animal/hostile/retaliate/goat/bighorn/calf

/mob/living/simple_animal/hostile/retaliate/goat/bighorn/attackby(obj/item/O, mob/user, params)
	if(stat == CONSCIOUS && istype(O, /obj/item/reagent_containers/glass)) // Should probably be bound into a proc at this point.
		udder.milkAnimal(O, user)
		return 1
	if(stat == CONSCIOUS && istype(O, food_type))
		if(is_calf)
			visible_message("<span class='alertalien'>[src] adorably chews the [O].</span>")
			qdel(O)
		if(!has_calf && !is_calf)
			has_calf = 1
			visible_message("<span class='alertalien'>[src] hungrily consumes the [O].</span>")
			qdel(O)
		else
			visible_message("<span class='alertalien'>[src] absently munches the [O].</span>")
			qdel(O)
	else
		return ..()

/mob/living/simple_animal/hostile/retaliate/goat/bighorn/Life()
	. = ..()
	if(stat == CONSCIOUS)
		if((prob(3) && has_calf))
			has_calf++
		if(has_calf > 10)
			has_calf = 0
			visible_message("<span class='alertalien'>[src] gives birth to a calf.</span>")
			new young_type(get_turf(src))

		if(is_calf)
			if((prob(3)))
				is_calf = 0
				udder = new()
				if(name == "bighorn lamb")
					name = "bighorn"
				else
					name = "bighorn"
				visible_message("<span class='alertalien'>[src] has fully grown.</span>")
		else
			udder.generateMilk()

/mob/living/simple_animal/hostile/retaliate/goat/bighorn/calf
	name = "bighoner lamb"
	resize = 0.7

/mob/living/simple_animal/hostile/retaliate/goat/bighorn/calf/Initialize() //calfs should not be a separate critter, they should just be a normal whatever with these vars
	. = ..()
	resize = 0.7
	update_transform()