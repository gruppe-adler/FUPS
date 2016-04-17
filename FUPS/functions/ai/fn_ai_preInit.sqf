/*

	Preinit function to ai package.

	PARAMS:
		NONE

	RETURNS:
		NONE

	AUTHOR: [W] Fett_Li

*/

FUPS_reinforcements_east = [];
FUPS_reinforcements_west = [];
FUPS_reinforcements_guer = [];
FUPS_reinforcements = [FUPS_reinforcements_west,FUPS_reinforcements_east,FUPS_reinforcements_guer];

// OnEachFrame handler variables
FUPS_oefGroups = [];
FUPS_oefGroups_toAdd = [];
FUPS_oefGroups_toDelete = [];
FUPS_oefClockPulse = 0;

// initialize global arrays
FUPS_enemies_west = [];
FUPS_enemies_east = [];
FUPS_enemies_guer = [];
FUPS_enemies = [FUPS_enemies_west,FUPS_enemies_east,FUPS_enemies_guer];

FUPS_share_west = [];
FUPS_share_east = [];
FUPS_share_guer = [];
FUPS_share = [FUPS_share_west,FUPS_share_east,FUPS_share_guer];

FUPS_shareNow_west = [];
FUPS_shareNow_east = [];
FUPS_shareNow_guer = [];
FUPS_shareNow = [FUPS_shareNow_west,FUPS_shareNow_east,FUPS_shareNow_guer];

FUPS_players = [];