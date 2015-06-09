private "_count";
_count = count (waypoints (_this select 0));
if (_count < 2) exitWith {};
for "_i" from 1 to (_count - 1) do {
	deleteWaypoint [(_this select 0),0];
};