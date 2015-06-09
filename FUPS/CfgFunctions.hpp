class FUPS {
	class enviroment {
		file = "FUPS\functions\enviroment";
		class log {};
		class simulation {};
	};
	class features {
		file = "FUPS\functions\features";
		class generateWP {};
		class randomSpawn {};
		class solUseBuilding {};
		class useBuilding {};
	};
	class information {
		file = "FUPS\functions\information";
		class ai_type {};
		class ai_type_init {};
		class fears {};
		class g_type {};
		class g_type_get {};
		class g_type_init {};
		class g_weapons {};
		class g_weapons_init {};
		class groupVehicles {};
		class isEffective {};
		class isPlayerGroup {};
		class isPlayerGroup_init {};
		class isSurrounded {};
		class v_type {};
		class v_type_init {};
		class v_weapons {};
		class v_weapons_init {};
	};
	class map {
		file = "FUPS\functions\map";
		class coverMarker {};
		class escapeDirection {};
		class getDir {};
		class inForest {};
		class inTown {};
		class markerData {};
		class nearestBuilding {};
		class posInMarker {};
		class randomMarkerPos {};
		class recMarkerRad {};
		class relpos {};
		class stayInside {};
	};
	class misc {
		file = "FUPS\functions\misc";
		class clearWP {};
		class getParams {};
		class getWaypoints {};
	};
	class attack {
		file = "FUPS\functions\tasks\attack";
		class task_attack_air {};
		class task_attack_man {};
		class task_attack_ship {};
		class task_attack_vehicle {};
	};
	class getOutOfWater {
		file = "FUPS\functions\tasks\getOutOfWater";
		class task_getOutOfWater {};
	};
	class hold {
		file = "FUPS\functions\tasks\hold";
		class task_hold_air {};
		class task_hold_man {};
		class task_hold_ship {};
		class task_hold_vehicle {};
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
	class main {
		file = "FUPS\functions";
		class do {};
		class main {};
		class mainHandler {};
		class preInit { preInit = 1; };
		class registerTask {};
		class reinforcement {};
		class setPatrolMarker {};
		class spawn {};
		class waitForTemplates {};
	};
};
