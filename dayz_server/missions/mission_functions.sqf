mission_timer = {
	private["_low_value","_high_value","_rand","_return"];
	_low_value = _this select 0;
	_high_value = _this select 1;

	_rand = round(random (_high_value - _low_value));
	_return = _low_value + _rand;
	
	_return;
};


mission_cleaner = {
	private ["_last_index", "_index", "_group"];
	while {true} do {
		sleep 600;
		_last_index = count mission_ai_groups;
		_index = 0;
		while {(_index < _last_index)} do
		{
			_group = mission_ai_groups select _index;
			if (count units (_group select 1) == 0) then {
				deleteGroup (_group select 1);
				missionNamespace setVariable [(_group select 0), nil];
				mission_ai_groups set [_index, "delete me"];
				mission_ai_groups = mission_ai_groups - ["delete me"];			
				_index = _index - 1;
				_last_index = _last_index - 1;
			};
			_index = _index + 1;
		};
	};
};


mission_nearbyPlayers = {
	private ["_pos", "_isNearList", "_isNear"];
	_pos = _this select 0;

	_isNearList = _pos nearEntities ["CAManBase", mission_blacklist_players_range];
	_isNear = false;
	
	// Check for Players & Ignore SARGE AI
	if ((count(_isNearList)) > 0) then {
		{
			if (isPlayer _x) then {
				_isNear = true;
			};
		} forEach _isNearList;
	};

	if !(_isNear) then {
		_isNearList = _pos nearEntities [["LandVehicle", "Air"], mission_blacklist_players_range];
		{
			{
				if (isPlayer _x) then {
					_isNear = true;
				};
			} forEach (crew _x);
		} forEach _isNearList;
	};
	_isNear
};

mission_nearbyBlackspot = {
	private ["_position", "_isNear", "_nearby"];
	_position = _this select 0;
	_isNear = false;
	
	_nearby = nearestObjects [_position, ["Plastic_Pole_EP1_DZ", "Info_Board_EP1"], mission_blacklist_range];
	
	if ((count _nearby) > 0) then {
		_isNear = true;
	};
	_isNear
};


mission_vehicle_pool = {
	private ["_veh_pool", "_vehicle", "_velimit", "_qty", "_veh_pool"];
	_veh_pool = [];
	{
		_vehicle = _x select 0;
		_velimit = _x select 1;
		_qty = {_x == _vehicle} count serverVehicleCounter;
		if (isNil {_qty}) then {
			_qty = 0;
		};
		if (_qty <= _velimit) then {
			_veh_pool = _veh_pool + [[_vehicle, _velimit]];
		};
	} forEach mission_dynamic_ai_vehicles;
	_veh_pool
};


mission_spawn_ai = {
	private ["_position","_snipers","_soldiers","_ai_setting","_marker2","_group2","_id1","_id2","_id3","_group1","_group3","_marker1","_marker3","_chance"];
	
	_position = _this select 0;
	_snipers = _this select 1;
	_soldiers = _this select 2;
	_ai_setting = (_this select 3) call BIS_fnc_selectRandom;

	_id1  = mission_id;
	mission_id  = mission_id  + 1;
	_id2 = mission_id;
	mission_id = mission_id + 1;
	_id3 = mission_id;
	mission_id = mission_id + 1;
	_group1 = 0;
	_group2 = 0;
	_group3 = 0;
	_marker1 = 0;
	_marker2 = 0;
	_marker3 = 0;
	
	_marker1 = createMarker [("SAR_mission_" + str(_id1)), _position];
	_marker1 setMarkerShape "RECTANGLE";
	_marker1 setMarkeralpha 0;
	_marker1 setMarkerType "Flag";
	_marker1 setMarkerBrush "Solid";
	_marker1 setMarkerSize [200,200];
	missionNamespace setVariable ["SAR_mission_" + str(_id1), _marker1];  
	_group1 = [missionNameSpace getVariable ("SAR_mission_" + str(_id1)), 3, _snipers, _soldiers, _ai_setting, false] call SAR_AI;

	_chance = (random 10);	
	switch (true) do {

		case (_chance <= 2):
		{
			// AI HELI 20% Chance  650 range
			_marker2 = createMarker [("SAR_mission_" + str(_id2)), _position];
			_marker2 setMarkerShape "RECTANGLE";
			_marker2 setMarkeralpha 0;
			_marker2 setMarkerType "Flag";
			_marker2 setMarkerBrush "Solid";
			_marker2 setMarkerSize [650,650];
			missionNamespace setVariable ["SAR_mission_" + str(_id2), _marker2];
			_group2 = [missionNameSpace getVariable ("SAR_mission_" + str(_id2)), 3, false] call SAR_AI_heli;
		};
		
		case (_chance <= 4):
		{
			// AI HELI 20% Chance 300 range
			_marker2 = createMarker [("SAR_mission_" + str(_id2)), _position];
			_marker2 setMarkerShape "RECTANGLE";
			_marker2 setMarkeralpha 0;
			_marker2 setMarkerType "Flag";
			_marker2 setMarkerBrush "Solid";
			_marker2 setMarkerSize [300,300];
			missionNamespace setVariable ["SAR_mission_" + str(_id2), _marker2];
			_group2 = [missionNameSpace getVariable ("SAR_mission_" + str(_id2)), 3, false] call SAR_AI_heli;
			[_group2] call mission_kill_vehicle_group;
		};
		
		case (_chance <= 7):
		{
			// AI Land Vehicles 30% Chance  300 range
			_marker2 = createMarker [("SAR_mission_" + str(_id2)), _position];
			_marker2 setMarkerShape "RECTANGLE";
			_marker2 setMarkeralpha 0;
			_marker2 setMarkerType "Flag";
			_marker2 setMarkerBrush "Solid";
			_marker2 setMarkerSize [300,300];
			missionNamespace setVariable ["SAR_mission_" + str(_id2), _marker2];
			_group2 = [missionNameSpace getVariable ("SAR_mission_" + str(_id2)), 3, [(mission_patrol_land_vehicles call BIS_fnc_selectRandom)], [[1,1,1]], false] call SAR_AI_land;
			[_group2] call mission_kill_vehicle_group;
		};
		
		default
		{
			// Extra AI Foot Patrol 30% Chance
			_marker2 = createMarker [("SAR_mission_" + str(_id2)), _position];
			_marker2 setMarkerShape "RECTANGLE";
			_marker2 setMarkeralpha 0;
			_marker2 setMarkerType "Flag";
			_marker2 setMarkerBrush "Solid";
			_marker2 setMarkerSize [200,200];
			missionNamespace setVariable ["SAR_mission_" + str(_id2), _marker2];  
			_group2 = [missionNameSpace getVariable ("SAR_mission_" + str(_id2)), 3, _snipers, _soldiers, _ai_setting, false] call SAR_AI;
		};
	};

	// Second Group of AI Soldiers
	_marker3 = createMarker [("SAR_mission_" + str(_id3)), _position];
	_marker3 setMarkerShape "RECTANGLE";
	_marker3 setMarkeralpha 0;
	_marker3 setMarkerType "Flag";
	_marker3 setMarkerBrush "Solid";
	_marker3 setMarkerSize [80,80];
	missionNamespace setVariable ["SAR_mission_" + str(_id3), _marker3];
	_group3 = [missionNameSpace getVariable ("SAR_mission_" + str(_id3)), 3, _snipers, _soldiers, _ai_setting, false] call SAR_AI;
	
	[[("SAR_mission_" + str(_id1)), _group1],[("SAR_mission_" + str(_id2)), _group2],[("SAR_mission_" + str(_id3)), _group3]];
};


mission_spawn_crates = {
	private ["_position", "_type", "_loot_type", "_crate"];

	_position = _this select 0;
	_type = _this select 1;
	_loot_type = _this select 2;

	_crate = createVehicle [_type, _position, [], 0, "CAN_COLLIDE"];
	clearWeaponCargoGlobal _crate;
	clearMagazineCargoGlobal _crate;
	[_crate, _loot_type] execVM "\z\addons\dayz_server\missions\misc\fillBoxes.sqf";
	_crate setVariable ["Sarge", 1, true];  // Stop Server Cleanup Killing Box
	_crate
};


mission_spawn_vehicle = {
	private ["_vehicle_class", "_position", "_spawnDMG", "_dir", "_vehicle", "_objPosition", "_num", "_allCfgLoots", "_iClass", "_itemTypes", "_index", "_weights", "_cntWeights", "_index", "_itemType"];

	
	_vehicle_class = _this select 0;
	_position = _this select 1;
	_spawnDMG = _this select 2;

	diag_log format ["DEBUG: Spawn Vehicle Position: %1", _position];
	
	_dir = round(random 180);
	
	_vehicle = createVehicle [_vehicle_class, _position, [], 0, "CAN_COLLIDE"];
	_vehicle setdir _dir;
	_vehicle setpos _position;	
	_objPosition = getPosATL _vehicle;

	// Add 0-4 loots to vehicle using random cfgloots 
	_num = floor(random 4);
	_allCfgLoots = ["trash","civilian","food","generic","medical","military","policeman","hunter","worker","clothes","militaryclothes","specialclothes","trash"];
	
	for "_x" from 1 to _num do {
		_iClass = _allCfgLoots call BIS_fnc_selectRandom;

		_itemTypes = [] + ((getArray (configFile >> "cfgLoot" >> _iClass)) select 0);
		_index = dayz_CLBase find _iClass;
		_weights = dayz_CLChances select _index;
		_cntWeights = count _weights;
		
		_index = floor(random _cntWeights);
		_index = _weights select _index;
		_itemType = _itemTypes select _index;
		_vehicle addMagazineCargoGlobal [_itemType,1];
	};
	diag_log format ["DEBUG MISSION: Vehicle: _objPosition: %1", _objPosition];
	[_vehicle, [_dir, _objPosition], _vehicle_class, _spawnDMG, "0"] call server_publishVeh;
	[_vehicle, mission_despawn_timer_min] spawn mission_kill_vehicle;
	serverVehicleCounter set [count serverVehicleCounter, _vehicle_class];
};


mission_kill_vehicle_group = {
	private ["_units", "_vehicle"];
	_units = units (_this select 0);
	_vehicle = objNull;
	
	{
		if ((vehicle _x) != _x) exitWith {
			_vehicle = (vehicle _x);
		};
	} forEach _units;
	
	if ((_vehicle isKindOf "LandVehicle") || (_vehicle isKindOf "Air")) then {
		[_vehicle, mission_despawn_timer_min] spawn mission_kill_vehicle;		
	} else {
		diag_log format ["DEBUG: MISSIONS: Kill Vehicle Group: Unknown: _vehicle: %1", _vehicle];
	};
};


mission_kill_vehicle = {
	private ["_vehicle","_timer","_blowup","_exit","_vehicle_id"];

	_vehicle = _this select 0;
	_timer = time + (_this select 1);
	_blowup = true;
	_exit = false;

	waitUntil{
		sleep 1;
		if (alive _vehicle) then {
			{
				if ((isPlayer _x) && (_x distance _vehicle <= 10)) then {
					_blowup = false;
					_exit = true;
				};
			} forEach playableUnits;
		} else {
			_blowup = true;
			_exit = true;
		};
		if (time > _timer) then {
			_blowup = true;
			_exit = true;
		};
		_exit
	};

	[_vehicle, "all"] spawn server_updateObject;
	sleep 5;
	_vehicle_id = _vehicle getVariable ["ObjectID","0"];
	if (_blowup) then {
		diag_log format ["DEBUG: Mission Code: Killing Vehicle ID: %1", _vehicle_id];
		_vehicle setDamage 1;
		[_vehicle, "DAYZ MISSION SYSTEM"] call vehicle_handleServerKilled;
	} else {
		diag_log format ["DEBUG: Mission Code: Saving Vehicle ID: %1", _vehicle_id];
	};
};


/*
mission_vehicle_playercheck = {
	diag_log ("TEST PLAYER CHECK ");
	diag_log format ["DEBUG VEHICLE PLAYER CHECK: %1", _this];
	_vehicle = _this select 0;
	_unit = _this select 1;
	
	if (isplayer _unit) then {
		_vehicle setVariable ["Mission Blowup", false, true];
	};
};


mission_kill_vehicle = {
	diag_log ("DEBUG MISSIONS: Kill Vehicle Initialized");
	_vehicle = _this select 0;
	_timer = _this select 1;
	diag_log format ["DEBUG: MISSIONS: Kill Vehicle: _vehicle: %1", _vehicle];
		
	// Add EventHandler for Vehicle
	diag_log ("DEBUG MISSIONS: addEvent");
	//_vehicle addEventHandler ["GetIn", { _this call mission_vehicle_playercheck } ];
	_veh addEventHandler ["GetIn", { diag_log ("DEBUG MISSIONS Missions TEST");} ];
	sleep _timer;
	
	// Prob not needed.. but just incase we will update vehicle in database
	[_vehicle, "all"] call server_updateObject;
	sleep 5;

	// Wait until no players are near vehicle & its still alive
	diag_log ("DEBUG MISSIONS: Wait Until No Players");
	_exit = false;
	waitUntil{
		sleep 1;
		if (alive _vehicle) then {
			{
				if !((isPlayer _x) && ((_x distance _vehicle) <= 10)) then {
					_exit = true;
				};
			} forEach playableUnits;
		} else {
			_exit = true;
		};
		if (!(_vehicle getVariable ["Mission Blowup", true])) then {
			_exit = true;
		};
		_exit
	};

	// Reset Event Handlers for Vehicle
	diag_log ("DEBUG MISSIONS: resetEvent");
	_vehicle call fnc_veh_ResetEH;
	
	// Checking if we are going to blow up Vehicle
	diag_log ("DEBUG MISSIONS: Vehicle Blowup Check");
	_blowup = _vehicle getVariable ["Mission Blowup", true];
	_vehicle_id = _vehicle getVariable ["ObjectID","0"];
	sleep 1;
	
	if (_blowup) then {
		diag_log format ["DEBUG: Mission Code: Killing Vehicle ID: %1", _vehicle_id];
		_vehicle setDamage 1;
		[_vehicle, "DAYZ MISSION SYSTEM"] call vehicle_handleServerKilled;
	} else {
		diag_log format ["DEBUG: Mission Code: Saving Vehicle ID: %1", _vehicle_id];
	};
};
*/


mission_spawn = {
	private ["_chance","_position","_mission_type","_isNear","_crates","_ai_info","_veh_pool","_vehicle","_vehicle_position","_crate_position","_type","_timeout","_group_1","_timeout2","_marker","_isNearPlayer","_isNearBlackspot","_vehicle_spawn","_marker_name","_group_2","_group_3"];
	diag_log ("DEBUG: Mission Code: Starting New Mission");

	// Spawn around buildings and 50% near roads
	_position = [];
	_mission_type = "";
	_chance = floor(random 2);
	
	// Try 10 Times to Find a Mission Spot
	for "_x" from 1 to 10 do {
		switch (_chance) do
		{
			case 0:
				{
					_mission_type = "Road";
					
					waitUntil{!isNil "BIS_fnc_selectRandom"};
					_position = RoadList call BIS_fnc_selectRandom;
					_position = _position modelToWorld [0,0,0];
				
					waitUntil{!isNil "BIS_fnc_findSafePos"};
					_position = [_position,0,100,5,0,2000,0] call BIS_fnc_findSafePos;
				};
			case 1:
				{
					_mission_type = "Building";		
					
					waitUntil{!isNil "BIS_fnc_selectRandom"};
					_position = BuildingList call BIS_fnc_selectRandom;
					_position = _position modelToWorld [0,0,0];
					
					waitUntil{!isNil "BIS_fnc_findSafePos"};
					_position = [_position,0,100,5,0,2000,0] call BIS_fnc_findSafePos;
				};
			case 2:
				{
					_mission_type = "Open Area";	
					
					waitUntil{!isNil "BIS_fnc_findSafePos"};
					_position = [getMarkerPos "center",0,5500,100,0,20,0] call BIS_fnc_findSafePos;
				};
		};

		_isNearPlayer = [_position] call mission_nearbyPlayers;
		_isNearBlackspot = [_position] call mission_nearbyBlackspot;
		if ((!_isNearPlayer) && (!_isNearBlackspot)) then {
			_x = 20;
		} else {
			_position = [];
		};
	};
	
	// only proceed if two params otherwise BIS_fnc_findSafePos failed and may spawn in air
	if ((count _position) == 2) then {
		diag_log ("DEBUG: Mission Code: Position Good");
		_chance = floor(random 100);
		_crates = [];
		_ai_info = [];
		_vehicle = 0;
		_vehicle_spawn = false;

		switch (_mission_type) do
		{
			case "Road":{
				if (_chance >= 75) then {
					_veh_pool = call mission_vehicle_pool;
					if ((count _veh_pool) > 0) then {
						waitUntil{!isNil "BIS_fnc_selectRandom"};
						_vehicle = (_veh_pool call BIS_fnc_selectRandom) select 0;
						_vehicle_position = [_position,0,50,5,0,2000,0] call BIS_fnc_findSafePos;
						[_vehicle, _vehicle_position, false] call mission_spawn_vehicle;
						_vehicle_spawn = true;
					};
				};

				//  Spawn Supplies -- Crates
				for "_i" from 0 to 5 do
				{
					waitUntil{!isNil "BIS_fnc_selectRandom"};
					_crate_position = [_position,0,30,3,0,2000,0] call BIS_fnc_findSafePos;
					if ((count _crate_position) == 2) then {
						waitUntil{!isNil "BIS_fnc_selectRandom"};
						_type = mission_crates call BIS_fnc_selectRandom;
						_crates = _crates + [[_crate_position, _type, "Random"] call mission_spawn_crates];
					};
				};
				_ai_info = [_position, 1, 5, ["patrol"]] call mission_spawn_ai;
				mission_ai_groups = mission_ai_groups + [(_ai_info select 0)] + [(_ai_info select 1)] + [(_ai_info select 2)];
				};

				
			case "Building":{
				if (_chance >= 75) then {
					_veh_pool = call mission_vehicle_pool;
					if ((count _veh_pool) > 0) then {
						waitUntil{!isNil "BIS_fnc_selectRandom"};
						_vehicle = (_veh_pool call BIS_fnc_selectRandom) select 0;
						_vehicle_position = [_position,0,50,5,0,2000,0] call BIS_fnc_findSafePos;
						[_vehicle, _vehicle_position, false] call mission_spawn_vehicle;
						_vehicle_spawn = true;
					};
				};
				
				//  Spawn Supplies -- Crates
				for "_i" from 0 to mission_num_of_crates do
				{
					waitUntil{!isNil "BIS_fnc_selectRandom"};
					_crate_position = [_position,0,30,3,0,2000,0] call BIS_fnc_findSafePos;
					if ((count _crate_position) == 2) then {
						waitUntil{!isNil "BIS_fnc_selectRandom"};
						_type = mission_crates call BIS_fnc_selectRandom;
						_crates = _crates + [[_crate_position,_type,"Random"] call mission_spawn_crates];
					};
				};
				_ai_info = [_position, 1, 4, ["fortify","fortify","patrol"]] call mission_spawn_ai;
				mission_ai_groups = mission_ai_groups + [(_ai_info select 0)] + [(_ai_info select 1)];
				};
				
				
			case "Open Area":{
				if (_chance >= 75) then {
					_veh_pool = call mission_vehicle_pool;
					if ((count _veh_pool) > 0) then {
						waitUntil{!isNil "BIS_fnc_selectRandom"};
						_vehicle = (_veh_pool call BIS_fnc_selectRandom) select 0;
						_vehicle_position = [_position,0,50,5,0,2000,0] call BIS_fnc_findSafePos;
						[_vehicle, _vehicle_position, false] call mission_spawn_vehicle;
						_vehicle_spawn = true;
					};
				};
				
				//  Spawn Supplies -- Crates
				for "_i" from 0 to mission_num_of_crates do
				{
					waitUntil{!isNil "BIS_fnc_selectRandom"};
					_crate_position = [_position,0,30,3,0,2000,0] call BIS_fnc_findSafePos;
					if ((count _crate_position) == 2) then {
						waitUntil{!isNil "BIS_fnc_selectRandom"};
						_type = mission_crates call BIS_fnc_selectRandom;
						_crates = _crates + [[_crate_position,_type,"Random"] call mission_spawn_crates];
					};
				};
				_ai_info = [_position, 1, 4, ["patrol","fortify","patrol"]] call mission_spawn_ai;
				mission_ai_groups = mission_ai_groups + [(_ai_info select 0)] + [(_ai_info select 1)];
			};
		};

		_marker_name = (((_ai_info select 0) select 0) + "_player_marker");
		_marker = createMarkerLocal [_marker_name, _position];
		if (_vehicle_spawn) then {
			_marker setMarkerColor "ColorBlue";
		} else {
			_marker setMarkerColor "ColorRed";
		};
		_marker setMarkerColor "ColorRed";
		_marker setMarkerShape "ELLIPSE";
		_marker setMarkerBrush "Grid";
		_marker setMarkerSize [300,300];

		customMissionWarning = [mission_warning_debug, _marker_name, _position, _vehicle_spawn, _vehicle];
		publicVariable "customMissionWarning";
		
		// Wait till all AI Dead or Mission Times Out

		_group_1 = ((_ai_info select 0) select 1);
		_group_2 = ((_ai_info select 1) select 1);
		_group_3 = ((_ai_info select 2) select 1);
		
		_timeout = time + mission_despawn_timer_min;
		waitUntil{
			sleep 30;
			if ((count units _group_1 == 0) && (count units _group_2 == 0) && (count units _group_3 == 0)) exitWith {true};
			if (time > _timeout) exitWith {true};
			false
		};
		
		
		// Wait till no Players within 200 metres && Mission Timeout Check for Crates
		_isNear = true;
		_timeout = time + ((mission_despawn_timer_max - mission_despawn_timer_min)/2);
		_timeout2 = _timeout + ((mission_despawn_timer_max - mission_despawn_timer_min)/2);
		while {_isNear} do
		{
			sleep 30;
			_isNear = [_crate_position, 500] call mission_nearbyPlayers;
			if ((!_isNear) && (time > _timeout)) then {
				_isNear = false;
			};
			if (time > _timeout2) then {
				_isNear = false;
			};
		};

		deleteMarker _marker_name;

		diag_log ("DEBUG: Mission Code: Removing AI + Crates");
		// Remove Crates
		{
			deleteVehicle _x;
		} forEach _crates;
		// Temp Kill All AI
		{
			_x setDamage 1;
		} forEach units _group_1;
		{
			_x setDamage 1;
		} forEach units _group_2;
		{
			_x setDamage 1;
		} forEach units _group_3;
	};
};