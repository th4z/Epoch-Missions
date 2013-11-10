diag_log ("DEBUG: Mission Code: Loading Mission Functions.......");

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


mission_check = {
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
		diag_log format ["DEBUG MISSIONS: Vehicles: _isNearList: %1", _isNearList];
		{
			{
				diag_log format ["DEBUG MISSIONS: Vehicle: _x: %1 Crew: %2", _x, (crew _x)];
				if (isPlayer _x) then {
					diag_log ("DEBUG MISSIONS: Vehicle: Player Detected");
					_isNear = true;
				};
			} forEach (crew _x);
		} forEach _isNearList;
	};
	_isNear
};


mission_veh_pool = {
	private ["_veh_pool", "_vehicle", "_velimit", "_qty", "_veh_pool"];
	_veh_pool = [];
	{
		_vehicle = _x select 0;
		_velimit = _x select 1;
		_qty = {_x == _vehicle} count serverVehicleCounter;
		if (isNil {_qty}) then {
			diag_log format ["DEBUG: Mission Code: Vehicle: %1 None DETECTED !!!", _vehicle];
			_qty = 0;
		};
		if (_qty <= _velimit) then {
			_veh_pool = _veh_pool + [[_vehicle, _velimit]];
		};
		diag_log format ["DEBUG: Mission Code: Vehicle: %1: Limit: %2: Qty: %3", _vehicle, _velimit, _qty];
	} forEach mission_dynamic_ai_vehicles;
	diag_log format ["DEBUG: Mission Code: AI Vehicle Pool: %1", _veh_pool];
	_veh_pool
};

mission_spawn_ai = {
	private ["_position", "_snipers", "_soldiers", "_ai_setting", "_marker", "_group", "_id2", "_group2", "_marker2"];
	diag_log format ["DEBUG: Mission SPAWN AI: _this: %1", _this];

	_position = _this select 0;
	_snipers = _this select 1;
	_soldiers = _this select 2;
	_ai_setting = (_this select 3) call BIS_fnc_selectRandom;
	// Spawn SARGE AI
	// 		Create Dynamic SARGE MARKER
	_id  = mission_id;
	mission_id  = mission_id  + 1;
	_marker = createMarker [("SAR_mission_" + str(_id)), _position];
	_marker setMarkerShape "RECTANGLE";
	_marker setMarkeralpha 0;
	_marker setMarkerType "Flag";
	_marker setMarkerBrush "Solid";
	_marker setMarkerSize [200,200];
	missionNamespace setVariable ["SAR_mission_" + str(_id), _marker];  
	_group = [missionNameSpace getVariable ("SAR_mission_" + str(_id)), 3, _snipers, _soldiers, _ai_setting, false] call SAR_AI;

	_id2 = mission_id;
	mission_id = mission_id + 1;
	_group2 = 0;
	if ((random 10) > 3) then {
		_marker2 = createMarker [("SAR_mission_" + str(_id2)), _position];
		_marker2 setMarkerShape "RECTANGLE";
		_marker2 setMarkeralpha 0;
		_marker2 setMarkerType "Flag";
		_marker2 setMarkerBrush "Solid";
		_marker2 setMarkerSize [650,650];
		missionNamespace setVariable ["SAR_mission_" + str(_id2), _marker2];
		_group2 = [missionNameSpace getVariable ("SAR_mission_" + str(_id2)), 3, false] call SAR_AI_heli;
	} else {
		_marker2 = createMarker [("SAR_mission_" + str(_id2)), _position];
		_marker2 setMarkerShape "RECTANGLE";
		_marker2 setMarkeralpha 0;
		_marker2 setMarkerType "Flag";
		_marker2 setMarkerBrush "Solid";
		_marker2 setMarkerSize [80,80];
		missionNamespace setVariable ["SAR_mission_" + str(_id2), _marker2];
		_group2 = [missionNameSpace getVariable ("SAR_mission_" + str(_id2)), 3, _snipers, _soldiers, _ai_setting, false] call SAR_AI;
	};
	[[("SAR_mission_" + str(_id)), _group],[("SAR_mission_" + str(_id2)), _group2]]
};


mission_spawn_crates = {
	private ["_position", "_type", "_loot_type", "_crate"];

	diag_log format ["DEBUG: Mission Code Spawn Loot: _this: %1", _this];
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
	private ["_vehicle", "_position", "_spawnDMG", "_dir", "_veh", "_objPosition", "_num", "_allCfgLoots", "_iClass", "_itemTypes", "_index", "_weights", "_cntWeights", "_index", "_itemType"];
	diag_log format ["DEBUG: Mission Code Spawn Vehicle: _this: %1", _this];

	_vehicle = _this select 0;
	_position = _this select 1;
	_spawnDMG = _this select 2;
	
	_dir = round(random 180);
	
	_veh = createVehicle [_vehicle, _position, [], 0, "CAN_COLLIDE"];
	_veh setdir _dir;
	_veh setpos _position;	
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

	[_veh,[_dir,_objPosition],_vehicle,_spawnDMG,"0"] call server_publishVeh;
	[_veh, 900] spawn mission_kill_vehicle;
};

mission_kill_vehicle = {
	private ["_vehicle", "_timer", "_loot_type", "_blowup"];

	_vehicle = _this select 0;
	_timer = time + _this select 1;
	
	waitUntil{
		sleep 1; 
		if {{isPlayer _x && _x distance _vehicle < 30} count playableunits > 0} exitWith {_blowup = false; true};
		if (time > _timer) exitWith {_blowup = true; true};
		false
	};
	if (_blowup) then {
		_vehicle setDamage 1;
	};
};

mission_spawn = {
	private ["_chance", "_position", "_mission_type", "_isNear", "_crates", "_ai_info", "_veh_pool", "_vehicle", "_vehicle_position", "_crate_position", "_type", "_text", "_timeout", "_group_0", "_group_1", "_last_index", "_index", "_missions", "_timeout2"];
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

		_isNear = [_position, 800] call mission_check;
		if (!_isNear) then {
			_x = 20;
		} else {
			_position = [];
		};
	};
	
	// only proceed if two params otherwise BIS_fnc_findSafePos failed and may spawn in air
	if ((count _position) == 2) then {
		_chance = floor(random 1);
		_crates = [];
		_ai_info = [];

		switch (_mission_type) do
		{
			case "Road":{
				if (_chance == 1) then {
					_veh_pool = call mission_veh_pool;
					if ((count _veh_pool) > 0) then {
						waitUntil{!isNil "BIS_fnc_selectRandom"};
						_vehicle = (_veh_pool call BIS_fnc_selectRandom) select 0;
						_vehicle_position = [_position,0,50,5,0,2000,0] call BIS_fnc_findSafePos;
						[_vehicle, _vehicle_position, false] call mission_spawn_vehicle;
					};
				};

				//  Spawn Supplies -- Crates
				for "_i" from 0 to 5 do
				{
					waitUntil{!isNil "BIS_fnc_selectRandom"};
					_crate_position = [_position,0,30,3,0,2000,0] call BIS_fnc_findSafePos;
					if ((count _crate_position) == 2) then {
						waitUntil{!isNil "BIS_fnc_selectRandom"};
						_type = missions_crates call BIS_fnc_selectRandom;
						_crates = _crates + [[_crate_position, _type, "Random"] call mission_spawn_crates];
					};
				};
				_ai_info = [_position, 2, 6, ["ambush","patrol"]] call mission_spawn_ai;
				mission_ai_groups = mission_ai_groups + [(_ai_info select 0)] + [(_ai_info select 1)];
				};

			case "Building":{
				if (_chance == 1) then {
					_veh_pool = call mission_veh_pool;
					if ((count _veh_pool) > 0) then {
						waitUntil{!isNil "BIS_fnc_selectRandom"};
						_vehicle = (_veh_pool call BIS_fnc_selectRandom) select 0;
						_vehicle_position = [_position,0,50,5,0,2000,0] call BIS_fnc_findSafePos;
						[_vehicle, _vehicle_position, false] call mission_spawn_vehicle;
					};
				};
				
				//  Spawn Supplies -- Crates
				for "_i" from 0 to missions_num_of_crates do
				{
					waitUntil{!isNil "BIS_fnc_selectRandom"};
					_crate_position = [_position,0,30,3,0,2000,0] call BIS_fnc_findSafePos;
					if ((count _crate_position) == 2) then {
						waitUntil{!isNil "BIS_fnc_selectRandom"};
						_type = missions_crates call BIS_fnc_selectRandom;
						_crates = _crates + [[_crate_position,_type,"Random"] call mission_spawn_crates];
					};
				};
				_ai_info = [_position, 2, 6, ["ambush","fortify","patrol"]] call mission_spawn_ai;
				mission_ai_groups = mission_ai_groups + [(_ai_info select 0)] + [(_ai_info select 1)];
				};
			case "Open Area":{
				_veh_pool = call mission_veh_pool;
				
				waitUntil{!isNil "BIS_fnc_selectRandom"};
				_vehicle = (_veh_pool call BIS_fnc_selectRandom) select 0;
				_vehicle_position = [_position,0,50,5,0,2000,0] call BIS_fnc_findSafePos;
				[_vehicle, _vehicle_position, false] call mission_spawn_vehicle;
			};
		};

		// Start Mission
		_text = "Bandits Have Been Spotted, Check your Map";
		customMissionGo = [(((_ai_info select 0) select 0) + "_player_marker"), _text, _position];
		publicVariable "customMissionGo";
		diag_log format ["DEBUG: Mission Code: AI INFO: %1", _ai_info];
		
		// Wait till all AI Dead or Mission Times Out

		_timeout = time + 1800;
		_group_0 = ((_ai_info select 0) select 1);
		_group_1 = ((_ai_info select 1) select 1);
		waitUntil{
			sleep 30;
			if ((count units _group_0 == 0) && (count units _group_1 == 1)) exitWith {true};
			if (time > _timeout) exitWith {true};
			false
		};

		
		_last_index = count Missions;
		_index = 0;
		while {(_index < _last_index)} do
		{
			_missions = Missions select _index;
			if ((_missions select 1) == _position) then {
				Missions set [_index, "delete me"];
				Missions = Missions - ["delete me"];			
				_index = _last_index + 1;
			};
			_index = _index + 1;
		};
		
		customMissionEnd = [(((_ai_info select 0) select 0) + "_player_marker"), _text, _position];
		publicVariable "customMissionEnd";

		// Wait till no Players within 200 metres && Mission Timeout Check for Crates
		_isNear = true;
		_timeout = time + 900;
		_timeout2 = _timeout + 900;
		while {_isNear} do
		{
			sleep 30;
			_isNear = [_crate_position, 500] call mission_check;
			if ((!_isNear) && (time > _timeout)) then {
				_isNear = false;
			};
			if (time > _timeout2) then {
				_isNear = false;
			};
		};

		diag_log ("DEBUG: Mission Code: Removing AI + Crates");
		// Remove Crates
		{
			deleteVehicle _x;
		} forEach _crates;
		// Temp Kill All AI
		{
			diag_log format ["DEBUG: Mission Code: Killing Group 0 AI %1", _x];
			_x setDamage 1;
		} forEach units _group_0;
		{
			diag_log format ["DEBUG: Mission Code: Killing Group 1 AI %1", _x];
			_x setDamage 1;
		} forEach units _group_1;
	};
};