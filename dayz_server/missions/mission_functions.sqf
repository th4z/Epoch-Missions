mission_nearbyPlayers = {
	private ["_pos", "_distance", "_isNearList", "_isNear"];
	_pos = _this select 0;
	_distance = _this select 1;

	_isNearList = _pos nearEntities ["CAManBase", _distance];
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
		_isNearList = _pos nearEntities [["LandVehicle", "Air"], _distance];
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
	// Spawn SARGE AI
	// 		Create Dynamic SARGE MARKER
	
	private ["_position", "_snipers", "_soldiers", "_ai_setting"];
	
	
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
	
	_dir = round(random 180);
	
	_vehicle = createVehicle [_vehicle_class, _position, [], 0, "CAN_COLLIDE"];
	_vehicle setdir _dir;
	_vehicle setpos _position;	
	_objPosition = getPosATL _veh;

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
		_veh addMagazineCargoGlobal [_itemType,1];
	};

	[_vehicle,[_dir,_objPosition],_vehicle_class,_spawnDMG,"0"] call server_publishVeh;
	[_vehicle, mission_despawn_timer_min] spawn mission_kill_vehicle;
	serverVehicleCounter set [count serverVehicleCounter, _vehicle_class];
};


mission_kill_vehicle_group = {
	private ["_group", "_units"];
	_group = _this select 0;
	_units = units _group;
	
	{
		if ((_x isKindOf "LandVehicle") || (_x isKindOf "Air")) then {
			[_x, mission_despawn_timer_min] spawn mission_kill_vehicle;		
		};
	} forEach _units;

};


mission_kill_vehicle = {
	private ["_vehicle", "_timer", "_blowup", "_exit"];

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
		diag_log format ["DEBUG: Mission Code: Killing Vehicle ID", _vehicle_id];
		_vehicle setDamage 1;
		[_vehicle, "DAYZ MISSION SYSTEM"] call vehicle_handleServerKilled;
	} else {
		diag_log format ["DEBUG: Mission Code: Saving Vehicle ID", _vehicle_id];
	};
};


mission_spawn = {
	diag_log ("DEBUG MISSIONS: Mission Spawn Started");
	private ["_chance", "_position", "_mission_type", "_isNear", "_crates", "_ai_info", "_veh_pool", "_vehicle", "_vehicle_position", "_crate_position", "_type", "_text", "_timeout", "_group_0", "_group_1", "_last_index", "_index", "_missions", "_timeout2", "_marker"];
	// Spawn around buildings and 50% near roads
	_chance = floor(random 2);
	_position = [];
	_mission_type = "";

	
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

		_isNear = [_position, 800] call mission_nearbyPlayers;
		if (!_isNear) then {
			_x = 20;
		} else {
			_position = [];
		};
	};
	
	// only proceed if two params otherwise BIS_fnc_findSafePos failed and may spawn in air
	if ((count _position) == 2) then {
		diag_log ("DEBUG: Mission Code: Starting New Mission");
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
				//_ai_info = [_position, 1, 5, ["ambush","patrol"]] call mission_spawn_ai;
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
				//_ai_info = [_position, 1, 4, ["ambush","fortify","patrol"]] call mission_spawn_ai;
				_ai_info = [_position, 1, 4, ["fortify","patrol"]] call mission_spawn_ai;
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
				//_ai_info = [_position, 1, 4, ["ambush","fortify","patrol"]] call mission_spawn_ai;
				_ai_info = [_position, 1, 4, ["fortify","patrol"]] call mission_spawn_ai;
				mission_ai_groups = mission_ai_groups + [(_ai_info select 0)] + [(_ai_info select 1)];
			};
		};

		// Start Mission
		_marker = createMarker[(((_ai_info select 0) select 0) + "_player_marker"), _position];
		if !(_vehicle_spawn) then {
			_marker setMarkerColor "ColorRed";
		} else {
			_marker setMarkerColor "ColorBlue";
		};
		_marker setMarkerShape "ELLIPSE";
		_marker setMarkerBrush "Grid";
		_marker setMarkerSize [300,300];
		
		_text = "Bandits Have Been Spotted, Check your Map";
		customMissionGo = [_text, _vehicle_spawn, _vehicle];
		publicVariable "customMissionGo";
		
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

		deleteMarker _marker;

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