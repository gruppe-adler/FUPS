/*

	Preinit function for core/scheduler package

	PARAMS:
		NONE

	RETURNS:
		NONE

	AUTHOR: [W] Fett_Li

*/

#include "macros.hpp"

FUPS_scheduler_groupQueue = [];
FUPS_scheduler_groupEnqueued = [];

FUPS_scheduler_groupScripts = [];
FUPS_scheduler_initScripts = [];

FUPS_scheduler_oefTopped = [];
FUPS_scheduler_oefToppedOnce = [];

FUPS_scheduler_oefID = -1;
