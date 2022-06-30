// USED FOR THE MIDROUND ANTAGONIST
/datum/antagonist/contractor
	name = "Drifting Contractor"
	antagpanel_category = "Drifting Contractor"
	preview_outfit = /datum/outfit/contractor_preview
	job_rank = ROLE_DRIFTING_CONTRACTOR
	antag_hud_name = "contractor"
	antag_moodlet = /datum/mood_event/focused
	show_to_ghosts = TRUE
	suicide_cry = "FOR THE CONTRACTS!!"
	/// The outfit the contractor is equipped with
	var/contractor_outfit = /datum/outfit/contractor

/datum/antagonist/contractor/proc/equip_guy()
	if(!ishuman(owner.current))
		return
	var/mob/living/carbon/human/person = owner.current
	person.equipOutfit(contractor_outfit)
	return TRUE

/datum/antagonist/contractor/on_gain()
	forge_objectives()
	. = ..()
	equip_guy()

/datum/antagonist/contractor/proc/forge_objectives()
	var/datum/objective/contractor_total/contract_objective = new
	contract_objective.owner = owner
	objectives += contract_objective

/datum/antagonist/contractor/roundend_report()
	var/list/report = list()

	if(!owner)
		CRASH("antagonist datum without owner")

	report += "<b>[printplayer(owner)]</b>"

	var/objectives_complete = TRUE
	if(length(objectives))
		report += printobjectives(objectives)
		for(var/datum/objective/objective as anything in objectives)
			if(!objective.check_completion())
				objectives_complete = FALSE
				break

	var/datum/contractor_hub/the_hub = GLOB.contractors[owner]
	report += the_hub?.contractor_round_end()

	if(!length(objectives) || objectives_complete)
		report += "<span class='greentext big'>The [name] was successful!</span>"
	else
		report += "<span class='redtext big'>The [name] has failed!</span>"

	return report.Join("<br>")

/datum/job/drifting_contractor
	title = ROLE_DRIFTING_CONTRACTOR
