# FUPS v2

-------------------------
Introduction
-------------------------

FUPS is an easy to use yet powerfull script to make ai patrol and attack properly in your mission.
It uses markers defining areas for ai to patrol.

-------------------------
Importing
-------------------------

To use FUPS into your mission simply copy the FUPS folder into your mission folder and add following to the class CfgFunctions in the description.ext. If the CfgFunctions don't exist, simply add it:
```
class CfgFunctions {
	#include "FUPS\CfgFunctions.hpp"
};
```

-------------------------
Usage
-------------------------

To make an AI gfroup use FUPS, just add this to it init-Field of _any_ but only one soldier of the group:
```
[this,"marker"] call FUPS_fnc_main;
```
Whereas the "marker" will be the marker in which the group will patrol.

There are optional parameters, listed in the file fn_main.sqf in the folder functions. You may want to look there. Also, FUPS_fnc_spawn and FUPS_fnc_reinforcement may look interesting to you.

-------------------------
Personalization
-------------------------

To personalize your overall FUPS experience you can modify variables in all settings... files in the FUPS folder.
Feel free to edit all the values, but don't delete any of them!

-------------------------
Changelog
-------------------------

### Next version
* _[Fixed]_ Scripting fixes
* [Changed] Scripting improved
