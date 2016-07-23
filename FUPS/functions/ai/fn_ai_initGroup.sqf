
#include "macros.hpp"

params ["_group"];

// AI status
_group setVariable ["FUPS_ai_combatStrength", 1];
_group setVariable ["FUPS_ai_gotHit", false];
_group setVariable ["FUPS_ai_lastDamage", 0];
_group setVariable ["FUPS_ai_weakened", false];

// AI knowledge
_group setVariable ["FUPS_ai_knowsAny", false];
_group setVariable ["FUPS_ai_targets", []];
_group setVariable ["FUPS_ai_nearestTarget", []];
_group setVariable ["FUPS_ai_directions", []];
_group setVariable ["FUPS_ai_enemies", []];
_group setVariable ["FUPS_ai_nearEnemies", []];
_group setVariable ["FUPS_ai_nearestEnemy", []];
_group setVariable ["FUPS_ai_fears", []];
_group setVariable ["FUPS_ai_theyGotUs", false];
_group setVariable ["FUPS_ai_surrounded", false];
_group setVariable ["FUPS_ai_headsdown", false];
