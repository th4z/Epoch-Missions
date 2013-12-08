private ["_mission_array","_wait","_handle","_mission_counter","_mission","_index","_last_index","_mission_unique_id"];
diag_log ("DEBUG: Mission Code: Start.......");

waitUntil{!isNil "BIS_fnc_findSafePos"};
waitUntil{!isNil "BIS_fnc_selectRandom"};

#include "config.sqf"

mission_ai_groups = [];
mission_markers = [];

call compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\Missions\mission_functions.sqf";
call compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\Missions\missions\standard.sqf";
call compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\Missions\missions\crash.sqf";

if (mission_hunter) then {
	call compile preprocessFile "Predator_fnc.sqf";	
	call compile preprocessFile "Predator_aux_fnc.sqf";
};


// Initialize Building Array
/*
mission_buildings_pos = [];
{
	_type = (_x select 0);
	mission_buildings_pos = mission_buildings_pos + [_type, [_type] call mission_find_buildings];
} forEach mission_buildings;
*/
sleep 60;

// Initialize mission array
_mission_array = [];
_mission_unique_id = 0;
for "_x" from 1 to mission_max_number do {
	_mission_unique_id = _mission_unique_id + 1;
	_handle = [str(_mission_unique_id)] spawn mission_spawn;
	_mission_array = _mission_array + [_handle];
	sleep 60; // Be kinder to Server + Spread Out Spawning Multiple Missions + wait for player debug monitor mission timeout
};	
_last_index = count _mission_array;		


// Main Loop for Spawning Missions
while {true} do {
	_wait = [mission_spawn_timer_min, mission_spawn_timer_max] call mission_timer;
	//_wait = 180;
	
	sleep _wait;
	if (((diag_fps) > mission_fps_check) && (mission_player_check <= (count playableUnits)))  then {

		// Getting Number of Running Bandit Missions
		_mission_counter = mission_max_number;
		{
			if (scriptDone _x) then {
				_mission_counter = _mission_counter - 1;
			};
		} forEach _mission_array;

		// Spawning Bandit Missions
		_index = 0;
		while {(_index < _last_index)} do
		{
			_mission = (_mission_array select _index);
			if (scriptDone _mission) then {
				if (((random 10) > 6) || (_mission_counter < mission_min_number)) exitWith {

					_mission_unique_id = _mission_unique_id + 1;
					_handle = [str(_mission_unique_id)] spawn mission_spawn;

					_mission_array set [_index, _handle];
					_mission_counter = _mission_counter + 1;
					sleep 60; // Be kinder to Server + Spread Out Spawning Multiple Missions + wait for player debug monitor mission timeout
				};
			};
			_index = _index + 1;
		};
	};
};