#include "header\header.hpp"

// Log every FUPS_fnc_log call -> you get the whole shit of debugging
FUPS_log = !isMultiplayer;

// Those for categories will be logged. If you leave out one of them, loggs regarding this category won't be logged.
// [[ERROR_LOG, ENVIROMENT_LOG, ACTIONS_LOG ,STATS_LOG],true] call FUPS_fnc_enableLog;
