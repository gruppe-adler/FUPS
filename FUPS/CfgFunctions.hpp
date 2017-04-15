class FUPS {
	version = "v2.3.0";

	#include "ai\CfgFunctions.hpp"
	#include "core\CfgFunctions.hpp"
	#include "hearing\CfgFunctions.hpp"
	#include "high-ai\CfgFunctions.hpp"
	#include "orientation\CfgFunctions.hpp"
	#include "panic\CfgFunctions.hpp"
	#include "simulation\CfgFunctions.hpp"
	#include "targeting\CfgFunctions.hpp"
	#include "tasks\CfgFunctions.hpp"

	class api {
		file = "FUPS\functions\api";
		class getTemplateSize {};
		class reinforcementsExist {};
		class reveal {};
		class setPatrolMarker {};
		class stop {};
	};
	class features {
		file = "FUPS\functions\features";
		class randomSpawn {};
		class solUseBuilding {};
		class useBuilding {};
	};
	class information {
		file = "FUPS\functions\information";
		class ai_type {};
		class ai_type_init {};
		class fears {};
		class g_centerPos {};
		class g_centerPos_get {};
		class g_centerPos_init {};
		class g_type {};
		class g_type_get {};
		class g_type_init {};
		class g_weapons {};
		class g_weapons_init {};
		class getUniformCamo {};
		class getUnitStance {};
		class isEffective {};
		class v_type {};
		class v_type_init {};
		class v_weapons {};
		class v_weapons_init {};
	};
	class main {
		file = "FUPS\functions";
		class main {};
		class preInit { preInit = 1; };
		class reinforcement {};
		class saveTemplate {};
		class spawn {};
	};
	class map {
		file = "FUPS\functions\map";
		class coverMarker {};
		class createMarkerFromData {};
		class escapeDirection {};
		class generateWP {};
		class getDir {};
		class inForest {};
		class inTown {};
		class isSurrounded {};
		class markerData {};
		class nearestBuilding {};
		class posInArea {};
		class randomMarkerPos {};
		class relpos {};
		class stayInside {};
	};
	class misc {
		file = "FUPS\functions\misc";
		class clearWP {};
		class getParams {};
		class getWaypoints {};
		class groupVehicles {};
		class selectOrEnlarge {};
	};
	class settings {
		class settings { file = "FUPS\settings.sqf"; preInit = 1; };
		class settings_debug { file = "FUPS\settings_debug.sqf"; preInit = 1; };
		class settings_hearing { file = "FUPS\settings_hearing.sqf"; preInit = 1; };
		class settings_panic { file = "FUPS\settings_panic.sqf"; preInit = 1; };
		class settings_targeting { file = "FUPS\settings_targeting.sqf"; preInit = 1; };
	};
};
