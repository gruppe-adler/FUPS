
#include "macros.hpp"

params ["_group"];

// AI knowledge
_group setVariable ["FUPS_ai_targets", []];
_group setVariable ["FUPS_ai_enemies", []];
_group setVariable ["FUPS_ai_nearEnemies", []];
_group setVariable ["FUPS_ai_fears", []];

_group setVariable ["FUPS_ai_target", objNull];
