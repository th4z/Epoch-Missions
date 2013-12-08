mission_spawn_standard = {
    private ["_vehicle","_vehicle_position","_position","_vehicle_spawn","_veh_pool","_type","_crates","_crate_position","_isNear","_chance","_mission_type","_marker_name","_marker","_group_1","_group_2","_group_3","_timeout","_timeout2","_ai_patrols","_group3","_mission_id"];
	
	_mission_id = _this select 0;
	_position = _this select 1;
	_mission_type = _this select 2;
	
	_chance = floor(random 100);
	_crates = [];
	_ai_patrols = [];
	_vehicle = 0;
	_vehicle_spawn = false;
	_max_crates = objNull;
	
	switch (_mission_type) do
	{
		case "Road":
		{
			if (_chance >= 50) then {
				_veh_pool = call mission_vehicle_pool;
				if ((count _veh_pool) > 0) then {
					_vehicle = (_veh_pool call BIS_fnc_selectRandom) select 0;
					_vehicle_position = [_position,0,50,5,0,2000,0] call BIS_fnc_findSafePos;
					[_vehicle, _vehicle_position, false] call mission_spawn_vehicle;
					_vehicle_spawn = true;
				};
			};

			//  Spawn Supplies -- Crates
			if (!_vehicle_spawn) then {
				_max_crates = mission_num_of_crates
			} else {
				_max_crates = mission_num_of_crates_plus_vehicle;
			};
			for "_i" from 0 to _max_crates do
			{
				_crate_position = [_position,0,30,3,0,2000,0] call BIS_fnc_findSafePos;
				if ((count _crate_position) == 2) then {
					
					_type = mission_crates call BIS_fnc_selectRandom;
					_crates = _crates + [[_crate_position, _type, "Random"] call mission_spawn_crates];
				};
			};
			_ai_patrols = ["patrol","fortify","patrol"];
		};

		case "Building":
		{
			if (_chance >= 50) then {
				_veh_pool = call mission_vehicle_pool;
				if ((count _veh_pool) > 0) then {
					_vehicle = (_veh_pool call BIS_fnc_selectRandom) select 0;
					_vehicle_position = [_position,0,50,5,0,2000,0] call BIS_fnc_findSafePos;
					[_vehicle, _vehicle_position, false] call mission_spawn_vehicle;
					_vehicle_spawn = true;
				};
			};
			
			//  Spawn Supplies -- Crates
			if (!_vehicle_spawn) then {
				_max_crates = mission_num_of_crates
			} else {
				_max_crates = mission_num_of_crates_plus_vehicle;
			};
			for "_i" from 0 to _max_crates do
			{
				
				_crate_position = [_position,0,30,3,0,2000,0] call BIS_fnc_findSafePos;
				if ((count _crate_position) == 2) then {
					_type = mission_crates call BIS_fnc_selectRandom;
					_crates = _crates + [[_crate_position,_type,"Random"] call mission_spawn_crates];
				};
			};
			_ai_patrols = ["fortify","fortify","patrol"];
		};
			
		case "Open Area":
		{
			if (_chance >= 80) then {
				_veh_pool = call mission_vehicle_pool;
				if ((count _veh_pool) > 0) then {
					_vehicle = (_veh_pool call BIS_fnc_selectRandom) select 0;
					_vehicle_position = [_position,0,50,5,0,2000,0] call BIS_fnc_findSafePos;
					[_vehicle, _vehicle_position, false] call mission_spawn_vehicle;
					_vehicle_spawn = true;
				};
			};
			
			//  Spawn Supplies -- Crates
			if (!_vehicle_spawn) then {
				_max_crates = mission_num_of_crates
			} else {
				_max_crates = mission_num_of_crates_plus_vehicle;
			};
			for "_i" from 0 to _max_crates do
			{
				_crate_position = [_position,0,30,3,0,2000,0] call BIS_fnc_findSafePos;
				if ((count _crate_position) == 2) then {
					_type = mission_crates call BIS_fnc_selectRandom;
					_crates = _crates + [[_crate_position,_type,"Random"] call mission_spawn_crates];
				};
			};
			_ai_patrols = ["patrol","fortify","patrol"];
		};
	};

	
	// SPAWN AI
	// Inital Group 200 metre range, 1 sniper, 4 riflemen
	_group_1_info = [(_mission_id + "-AIGroup1"), "SAR_AI", _position, 200, 1, 4, _ai_patrols] call mission_spawn_ai;
	_group_1 = _group_1_info select 1;
	
	// Second Group 80 metre range, 1 sniper, 4 riflemen
	_group_2_info = [(_mission_id + "-AIGroup2"), "SAR_AI", _position, 80, 1, 4, _ai_patrols] call mission_spawn_ai;
	_group_2 = _group_2_info select 1;
	
	// Third Group
	_group_3_info = objNull;
	_group_3 = objNull;
	
	_chance = (random 10);
	switch (true) do {
        
        case (_chance <= 2):
        {
			_group_3_info = [(_mission_id + "-AIGroup3"), "SAR_AI_HELI", _position, 650, 1, 4, _ai_patrols] call mission_spawn_ai;
			_group_3 = _group_3_info select 1;
			[_group_3] call mission_kill_vehicle_group;
        };
        
        case (_chance <= 4):
        {
			_group_3_info = [(_mission_id + "-AIGroup3"), "SAR_AI_HELI", _position, 300, 1, 4, _ai_patrols] call mission_spawn_ai;
			_group_3 = _group_3_info select 1;
            [_group_3] call mission_kill_vehicle_group;
        };
        
        case (_chance <= 7):
        {
			_group_3_info = [(_mission_id + "-AIGroup3"), "SAR_AI_LAND", _position, 300, 1, 4, _ai_patrols] call mission_spawn_ai;
			_group_3 = _group_3_info select 1;
            [_group_3] call mission_kill_vehicle_group;
        };
        
        default
        {
			_group_3_info = [(_mission_id + "-AIGroup3"), "SAR_AI", _position, 200, 1, 4, _ai_patrols] call mission_spawn_ai;
			_group_3 = _group_3_info select 1;
        };
    };

	
	// Player Markers
	_marker_name = (_mission_id + "_player_marker");
	if (_vehicle_spawn) then {
		[_marker_name, _position, "ColorBlue", true] call mission_add_marker;
	} else {
		[_marker_name, _position, "ColorRed", true] call mission_add_marker;
	};
	
	customMissionWarning = [_mission_type, mission_warning_debug, _marker_name, _position, _vehicle_spawn, _vehicle];
	publicVariable "customMissionWarning";

	// Wait till all AI Dead or Mission Times Out

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

	[_marker_name, true] call mission_delete_marker;

	diag_log ("DEBUG: Mission Code: Removing AI + Crates");
	// Remove Crates
	{
		deleteVehicle _x;
	} forEach _crates;

	// Temp Kill All AI
	{
		_x setDamage 1;
	} forEach units _group_1;
	deletemarker (_group_1_info select 0);
	
	{
		_x setDamage 1;
	} forEach units _group_2;
	deletemarker (_group_2_info select 0);
	
	{
		_x setDamage 1;
	} forEach units _group_3;
	deletemarker (_group_3_info select 0);
};