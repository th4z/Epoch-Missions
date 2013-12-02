private ["_bandit_missions","_wait","_handle","_mission_counter","_mission","_index","_last_index"];
diag_log ("DEBUG: Mission Code: Start.......");

#include "config.sqf"

call compile preprocessFileLineNumbers "\z\addons\dayz_server\missions\mission_functions.sqf";

mission_id = 0;
mission_ai_groups = [];
sleep 60;

// Initialize mission array
_bandit_missions = [];
for "_x" from 1 to mission_max_number do {
	_handle = [] spawn mission_spawn;
	_bandit_missions = _bandit_missions + [_handle];
	sleep 300; // Be kinder to Server + Spread Out Spawning Multiple Missions + wait for player debug monitor mission timeout
};	
_last_index = count _bandit_missions;		

// Start Mission Variable Cleaner (i.e expired map markers etc, ai groups)
[] spawn mission_cleaner;

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
		} forEach _bandit_missions;

		// Spawning Bandit Missions
		_index = 0;
		while {(_index < _last_index)} do
		{
			_mission = (_bandit_missions select _index);
			if (scriptDone _mission) then {
				if (((random 10) > 4) || (_mission_counter < mission_min_number)) exitWith {
					_handle = [] spawn mission_spawn;
					_bandit_missions set [_index, _handle];
					_mission_counter = _mission_counter + 1;
					sleep 30; // Be kinder to Server + Spread Out Spawning Multiple Missions + wait for player debug monitor mission timeout
				};
			};
			_index = _index + 1;
		};
	};
};