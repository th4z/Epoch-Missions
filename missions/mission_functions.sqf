diag_log ("DEBUG: Mission Code: Loading Mission Functions.......");

mission_cleaner = {
	while {true} do {
		sleep 600;
		// Remove AI Group + Map Marker if all units are dead
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
				_index = _index -1;
			};
			_index = _index + 1;
		};
	};
};


mission_check = {
	private ["_distance", "_isNearList", "_isNear", "_pos"];
	_pos = _this select 0;
	_distance = _this select 1;
	// Check if Player is within 200 Metres...
	// Need to add check to parse & check entities are playable i.e not SARGE AI
	_isNearList = _pos nearEntities ["CAManBase",_distance];
	_isNear = false;
	
	// Check for Players & Ignore SARGE AI
	if ((count(_isNearList)) != 0) then {
		{
			if (vehicle _x getVariable ["Sarge",0] == 0) then {
				_isNear = true;
			};
		} forEach _isNearList;
	};
	_isNear
};

// TODO ADD Code to Generate List of Vehicles Available to Spawn onto Server....
mission_veh_pool = {
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
	} forEach dynamic_ai_vehicles;
	diag_log format ["DEBUG: Mission Code: AI Vehicle Pool: %1", _veh_pool];
	_veh_pool
};

mission_spawn_ai = {
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

	
	_rNumber = floor(random 10);
	if (_rNumber > 3) then {
		_id2 = mission_id;
		mission_id = mission_id + 1;
		_marker2 = createMarker [("SAR_mission_" + str(_id2)), _position];
		_marker2 setMarkerShape "RECTANGLE";
		_marker2 setMarkeralpha 0;
		_marker2 setMarkerType "Flag";
		_marker2 setMarkerBrush "Solid";
		_marker2 setMarkerSize [650,650];
		missionNamespace setVariable ["SAR_mission_" + str(_id2), _marker];
		_group2 = [missionNameSpace getVariable ("SAR_mission_" + str(_id2)), 3, false] call SAR_AI_heli;
	} else {
		_marker2 = createMarker [("SAR_mission_" + str(_id2)), _position];
		_marker2 setMarkerShape "RECTANGLE";
		_marker2 setMarkeralpha 0;
		_marker2 setMarkerType "Flag";
		_marker2 setMarkerBrush "Solid";
		_marker2 setMarkerSize [80,80];
		missionNamespace setVariable ["SAR_mission_" + str(_id2), _marker];
		_group2 = [missionNameSpace getVariable ("SAR_mission_" + str(_id2)), 3, _snipers, _soldiers, _ai_setting, false] call SAR_AI;
	};
	[[("SAR_mission_" + str(_id)), _group],[("SAR_mission_" + str(_id2)), _group2]]
};


mission_spawn_crates = {
	// Spawn Crates  [_crate_position,_type,"Random"] call mission_spawn_crates
	diag_log format ["DEBUG: Mission Code Spawn Loot: _this: %1", _this];
	_position = _this select 0;
	_type = _this select 1;
	_loot_type = _this select 2;

	//TODO: Add check that loot position is clear of objects i.e vehicles ???
	_crate = createVehicle [_type, _position, [], 0, "CAN_COLLIDE"];
	[_crate, _loot_type] execVM "\z\addons\dayz_server\missions\misc\fillBoxes.sqf";
	_crate setVariable ["Sarge", 1, true];  // Stop Server Cleanup Killing Box
	_crate
};


mission_spawn_vehicle = {
	diag_log format ["DEBUG: Mission Code Spawn Vehicle: _this: %1", _this];
	//15:00:40 "DEBUG: Mission Code Spawn Vehicle: _this: [["Mi17_DZ",1],[13041,12753.5],false]"
	_vehicle = _this select 0;
	_position = _this select 1;
	_spawnDMG = _this select 2;
	
	_dir = round(random 180);

	
	_veh = createVehicle [_vehicle, _position, [], 0, "CAN_COLLIDE"];
	_veh setdir _dir;
	_veh setpos _position;	
	_objPosition = getPosATL _veh;

	// Add 0-3 loots to vehicle using random cfgloots 
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
		//diag_log("DEBUG: spawed loot inside vehicle " + str(_itemType));
	};

	[_veh,[_dir,_objPosition],_vehicle,_spawnDMG,"0"] call server_publishVeh;
};


mission_spawn = {
	diag_log ("DEBUG: Mission Code: Mission Spawn Start 1....");
	// Spawn around buildings and 50% near roads
	_chance = floor(random 2);
	_position = [];
	_mission_type = "";
	
	diag_log format ["DEBUG: Mission Code 1: _chance: %1", _chance];
	
	switch (_chance) do
	{
		// TODO ADD CHECK FOR PLAYERS!!!!!
		case 0:
			{
			diag_log ("DEBUG: Mission Code: Mission Spawn Start 1a....");
			_mission_type = "Road";
			
			waitUntil{!isNil "BIS_fnc_selectRandom"};
			_position = RoadList call BIS_fnc_selectRandom;
			diag_log format ["DEBUG: Mission Code 1a: _position: %1", _position];
			_position = _position modelToWorld [0,0,0];
			diag_log format ["DEBUG: Mission Code 1a: _position: %1", _position];
		
			waitUntil{!isNil "BIS_fnc_findSafePos"};
			_position = [_position,0,100,5,0,2000,0] call BIS_fnc_findSafePos;
			diag_log format ["DEBUG: Mission Code 1a: _position: %1", _position];
			
			diag_log format ["DEBUG: Mission Code 1a: RoadList: %1", RoadList];
			};
		case 1:
			{
			diag_log ("DEBUG: Mission Code: Mission Spawn Start 1b....");
			_mission_type = "Building";		
			
			waitUntil{!isNil "BIS_fnc_selectRandom"};
			_position = BuildingList call BIS_fnc_selectRandom;
			diag_log format ["DEBUG: Mission Code 1b: _position: %1", _position];
			_position = _position modelToWorld [0,0,0];
			diag_log format ["DEBUG: Mission Code 1b: _position: %1", _position];
			
			waitUntil{!isNil "BIS_fnc_findSafePos"};
			_position = [_position,0,100,5,0,2000,0] call BIS_fnc_findSafePos;
			diag_log format ["DEBUG: Mission Code 1b: _position: %1", _position];

			diag_log format ["DEBUG: Mission Code 1b: BuildingList: %1", BuildingList];
			};
		case 2:
			{
			diag_log ("DEBUG: Mission Code: Mission Spawn Start 1c....");
			_mission_type = "Open Area";	
			
			waitUntil{!isNil "BIS_fnc_findSafePos"};
			_position = [getMarkerPos "center",0,5500,100,0,20,0] call BIS_fnc_findSafePos;
			};
	};
	diag_log format ["DEBUG: Mission Code 1: _position: %1", _position];
	diag_log format ["DEBUG: Mission Code 1: _mission_type: %1", _mission_type];
	// only proceed if two params otherwise BIS_fnc_findSafePos failed and may spawn in air
	if ((count _position) == 2) then {
		_chance = floor(random 1);
		_crates = [];
		_ai_info = [];

		switch (_mission_type) do
		{
			case "Road":{
				diag_log ("DEBUG: Mission Code: Mission Spawn Vehicle Road....");
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
				diag_log ("DEBUG: Mission Code: Mission Spawn Loot Road....");
				for "_i" from 0 to 4 do
				{
					waitUntil{!isNil "BIS_fnc_selectRandom"};
					_crate_position = [_position,0,50,3,0,2000,0] call BIS_fnc_findSafePos;
					if ((count _crate_position) == 2) then {
						waitUntil{!isNil "BIS_fnc_selectRandom"};
						_type = ["USVehicleBox","USVehicleBox","USLaunchersBox","USVehicleBox"] call BIS_fnc_selectRandom;
						_crates = _crates + [[_crate_position, _type, "Random"] call mission_spawn_crates];
					};
				};
				_ai_info = [_position, 2, 6, ["ambush","patrol"]] call mission_spawn_ai;
				mission_ai_groups = mission_ai_groups + [(_ai_info select 0)] + [(_ai_info select 1)];
				};
			case "Building":{
				diag_log ("DEBUG: Mission Code: Mission Spawn Vehicle Building....");
				if (_chance == 1) then {
					_veh_pool = call mission_veh_pool;
					if ((count _veh_pool) > 0) then {
						waitUntil{!isNil "BIS_fnc_selectRandom"};
						_vehicle = (_veh_pool call BIS_fnc_selectRandom) select 0;
						_vehicle_position = [_position,0,50,5,0,2000,0] call BIS_fnc_findSafePos;
						[_vehicle, _vehicle_position, false] call mission_spawn_vehicle;
					};
				};
				
				diag_log ("DEBUG: Mission Code: Mission Spawn Loot Building....");
				//  Spawn Supplies -- Crates
				for "_i" from 0 to 4 do
				{
					waitUntil{!isNil "BIS_fnc_selectRandom"};
					_crate_position = [_position,0,50,3,0,2000,0] call BIS_fnc_findSafePos;
					if ((count _crate_position) == 2) then {
						waitUntil{!isNil "BIS_fnc_selectRandom"};
						_type = ["USVehicleBox","USVehicleBox","USLaunchersBox","USVehicleBox"] call BIS_fnc_selectRandom;
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
		diag_log ("DEBUG: Mission Code: Mission Spawn Start 2....");
		_text = "Bandits Have Been Spotted, Check your Map";
		[nil,nil,rTitleText, _text, "PLAIN",10] call RE;
		MCoords = _position;
		publicVariable "MCoords";
		[] execVM "debug\addmarkers75.sqf";
		
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
		
		diag_log ("DEBUG: Mission Code: Mission Spawn Start 3....");
		// Send Message to Players about mission completed / failed
		if ((count units _group_0 == 0) && (count units _group_1 == 1)) then {
			_text = (_mission_info select 8);
			diag_log ("DEBUG: Mission Code: AI DEAD");
		} else {
			_text = (_mission_info select 9);
			diag_log ("DEBUG: Mission Code: Mission Timed Out");
		};

		diag_log ("DEBUG: Mission Code: Mission Spawn Start 4....");
		// Remove Map Marker
		[nil,nil,rTitleText, _text, "PLAIN",10] call RE;
		[] execVM "debug\remmarkers75.sqf";
		MCoords = 0;
		publicVariable "MCoords";

		diag_log ("DEBUG: Mission Code: Mission Spawn Start 5....");
		// Wait till no Players within 200 metres && Mission Timeout Check for Crates
		_isNear = true;
		_timeout = time + 600;
		_timeout2 = _timeout + 900;
		while {_isNear} do
		{
			sleep 30;
			_isNear = [(_mission_info select 0), 200] call mission_check;
			if ((!_isNear) && (time > _timeout)) then {
				_isNear = false;
			};
			if (time > _timeout2) then {
				_isNear = false;
			};
		};

		diag_log ("DEBUG: Mission Code: Mission Spawn Start 6....");
		// Remove Crates
		{
			deleteVehicle _x;
		} forEach _crates;
		// Temp Kill All AI
		{
			_x setDamage 1;
		} forEach units _group_0;
		{
			_x setDamage 1;
		} forEach units _group_1;
	};
};