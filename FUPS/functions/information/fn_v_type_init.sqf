#include "..\..\header\header.hpp"

params ["_v"];

private _type = -1;

switch (true) do {
	case (_v isKindOf "Man"): { _type = 0 };
	case (_v isKindOf "LandVehicle"): { _type = 1 },
	case (_v isKindOf "Air"): { _type = 2 };
	case (_v isKindOf "Ship"): { _type = 3 };
};

_v setVariable ["FUPS_type",_type];

_type