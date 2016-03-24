class FUPS {
	version = "v2.2.27";

	class api {
		file = "FUPS\functions\api";
		class getTemplateSize {};
		class reinforcementsExist {};
		class reveal {};
		class setPatrolMarker {};
		class stop {};
	};
	class attack {
		file = "FUPS\functions\tasks\attack";
		class task_attack_air {};
		class task_attack_man {};
		class task_attack_ship {};
		class task_attack_vehicle {};
	};
	class enviroment {
		file = "FUPS\functions\enviroment";
		class log {};
		class simulation {};
	};
	class features {
		file = "FUPS\functions\features";
		class randomSpawn {};
		class solUseBuilding {};
		class useBuilding {};
	};
	class getOutOfWater {
		file = "FUPS\functions\tasks\getOutOfWater";
		class task_getOutOfWater {};
	};
	class hearing {
		file = "FUPS\functions\hearing";
		class hearing_eh {};
	};
	class hold {
		file = "FUPS\functions\tasks\hold";
		class task_hold_air {};
		class task_hold_man {};
		class task_hold_ship {};
		class task_hold_vehicle {};
	};
	class information {
		file = "FUPS\functions\information";
		class ai_type {};
		class ai_type_init {};
		class g_centerPos {};
		class g_centerPos_get {};
		class g_centerPos_init {};
		class g_type {};
		class g_type_get {};
		class g_type_init {};
		class g_weapons {};
		class g_weapons_init {};
		class v_type {};
		class v_type_init {};
		class v_weapons {};
		class v_weapons_init {};
	};
	class main {
		file = "FUPS\functions";
		class addEventHandler {};
		class do {};
		class main {};
		class mainHandler {};
		class preInit { preInit = 1; };
		class registerTask {};
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
		class posInMarker {};
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
		class mainHandlerOverhead {};
	};
	class panic {
		file = "FUPS\functions\panic";
		class lowerPanic {};
		class raisePanic {};
	};
	class patrol {
		file = "FUPS\functions\tasks\patrol";
		class task_patrol {};
	};
	class reinforcement {
		file = "FUPS\functions\tasks\reinforcement";
		class task_reinf {};
	};
	class retreat {
		file = "FUPS\functions\tasks\retreat";
		class task_retreat {};
	};
	class settings {
		class settings { file = "FUPS\settings.sqf"; preInit = 1; };
		class settings_debug { file = "FUPS\settings_debug.sqf"; preInit = 1; };
		class settings_hearing { file = "FUPS\settings_hearing.sqf"; preInit = 1; };
		class settings_panic { file = "FUPS\settings_panic.sqf"; preInit = 1; };
		class settings_targeting { file = "FUPS\settings_targeting.sqf"; preInit = 1; };
	};
	class targeting {
		file = "FUPS\functions\targeting";
		class fears {};
		class getUniformCamo {};
		class getUnitStance {};
		class isEffective {};
		class targeting_getChance {};
		class targeting_getMapValue {};
		class targeting_getThreshold {};
		class targeting_increaseThreshold {};
	};
};
