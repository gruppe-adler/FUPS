// Create a test marker
private _marker = createMarker ["FUPS_testMarker",[200,200,0]];
_marker setMarkerShape "RECTANGLE";
_marker setMarkerSize [random 200,random 200];
_marker setMarkerDir random 360;

// Create a test trigger
private _trigger = createTrigger ["EmptyDetector", [200,200,0]];
_trigger setTriggerArea [random 200,random 200, random 360, true];

private _testarea = [_marker] call FUPS_fnc_markerData;

[_trigger] call FUPS_fnc_markerData;
[["testmarker",_trigger,[random worldSize, random worldSize,0]]] call fups_fnc_covermarker;
[_testarea] call FUPS_fnc_createMarkerFromData;
[0,3,45,190] call FUPS_fnc_escapeDirection;
[[random worldSize, random worldSize,0],[random worldSize, random worldSize,0]] call FUPS_fnc_getDir;
[[random worldSize, random worldSize,0]] call FUPS_fnc_inForest;
[[random worldSize, random worldSize,0]] call FUPS_fnc_inTown;
[0,1,45,300] call FUPS_fnc_isSurrounded;
[[random worldSize, random worldSize,0],50] call FUPS_fnc_nearestBuilding;
[_testarea,[random worldSize, random worldSize,0]] call FUPS_fnc_posInMarker;
[[random worldSize, random worldSize,0],random 100,random 360] call FUPS_fnc_relPos;
