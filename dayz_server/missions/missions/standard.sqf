mission_spawn_standard = {
    private ["_vehicle","_vehicle_position","_position","_vehicle_spawn","_veh_pool","_type","_crates","_crate_position","_ai_info","_isNear","_chance","_mission_type","_marker_name","_marker","_group_1","_group_2","_group_3","_timeout","_timeout2"];
	
	_mission_id = _this select 0;
	_position = _this select 1;
	_mission_type = _this select 2;
	
	_chance = floor(random 100);
	_crates = [];
	_ai_info = [];
	_vehicle = 0;
	_vehicle_spawn = false;

	switch (_mission_type) do
	{
		case "Road":{
			if (_chance >= 40) then {
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
					_crates = _crates + [[_crate_position, _type, "Random"] call mission_spawn_crates];
				};
			};
			_ai_info = [("StandardRoad" + _mission_id), _position, 1, 5, ["patrol"]] call mission_spawn_ai;
			mission_ai_groups = mission_ai_groups + [(_ai_info select 0)] + [(_ai_info select 1)] + [(_ai_info select 2)];
			};

			
		case "Building":{
			if (_chance >= 40) then {
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
			_ai_info = [("StandardBuilding" + _mission_id), _position, 1, 4, ["fortify","fortify","patrol"]] call mission_spawn_ai;
			mission_ai_groups = mission_ai_groups + [(_ai_info select 0)] + [(_ai_info select 1)] + [(_ai_info select 2)];
			};
			
			
		case "Open Area":{
			if (_chance >= 40) then {
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
			_ai_info = [("StandardOpen" + _mission_id), _position, 1, 4, ["patrol","fortify","patrol"]] call mission_spawn_ai;
			mission_ai_groups = mission_ai_groups + [(_ai_info select 0)] + [(_ai_info select 1)] + [(_ai_info select 2)];
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

	customMissionWarning = ["Standard", mission_warning_debug, _marker_name, _position, _vehicle_spawn, _vehicle];
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