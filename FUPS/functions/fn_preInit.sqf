/*

	Sets basic variables & tasks, called during preInit

	PARAMS:
		-

	RETURN:
		-

	AUTHOR: [W] Fett_Li

*/

#include "..\header\header.hpp"

// Generall variables
FUPS_cycleTime = 0;
FUPS_hearing_enabled = getText (missionconfigfile >> "Extended_Fired_Eventhandlers" >> "AllVehicles" >> "fups_audio_fired") != "";

// Variable to check if FUPS is loaded
FUPS_present = true;

// Save the side order for all arrays
FUPS_sideOrder = [west,east,independent];

FUPS_templates  = [];
