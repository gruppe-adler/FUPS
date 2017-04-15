
#include "macros.hpp"

[FUPS_fnc_panic_groupInit] call FUPS_fnc_scheduler_addInitScript;
[FUPS_fnc_panic_isPanicked, 1, 1] call FUPS_fnc_scheduler_addGroupScript;
