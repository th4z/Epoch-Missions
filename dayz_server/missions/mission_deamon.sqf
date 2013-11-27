private ["_bandit_missions", "_null", "_wait", "_handle"];
diag_log ("DEBUG: Mission Code: Start.......");

#include "config.sqf"

fnc_hTime = compile preprocessFileLineNumbers "\z\addons\dayz_server\missions\misc\fnc_hTime.sqf"; //Random integer selector for mission wait time
call compile preprocessFileLineNumbers "\z\addons\dayz_server\missions\mission_functions.sqf";

mission_id = 0;
mission_ai_groups = [];
sleep 300;

// Initialize mission array
_bandit_missions = [];
for "_x" from 1 to mission_max_number do {
	_handle = [] spawn mission_spawn;
	_bandit_missions = _bandit_missions + [_handle];
};	
_last_index = count _bandit_missions;		

// Start Mission Variable Cleaner (i.e expired map markers etc, ai groups)
[] spawn mission_cleaner;

diag_log format ["DEBUG: Mission Code: Max Missions %1", (count _bandit_missions)];
// Main Loop for Spawning Missions
while {true} do {
	_wait = [mission_spawn_timer_max, mission_spawn_timer_min] call fnc_hTime;
	//_wait = 180;
	sleep _wait;
	if ((diag_fps) > mission_fps_check) then {

		// Getting Number of Running Bandit Missions
		_mission_counter = 0;
		{
			if (scriptDone _x) then {
				_mission_counter = _mission_counter + 1;
			};
		} forEach _bandit_missions;

		// Spawning Bandit Missions
		_index = 0;
		while {(_index < _last_index)} do
		{
			_mission = (_bandit_missions select _index);
			diag_log format ["DEBUG: Mission Code: Handle: %1", _mission];
			if (scriptDone _mission) then {
				diag_log ("DEBUG: Mission Code: Spawn Check ");
				if (((random 10) > 4) || (_mission_counter < mission_min_number)) exitWith {
					diag_log ("DEBUG: Mission Code: Spawn");
					_handle = [] spawn mission_spawn;
					_bandit_missions set [_index, _handle];
					_mission_counter = _mission_counter + 1;
				};
			} else { 
				diag_log ("DEBUG: Mission Code: Still Running");
			};
			_index = _index + 1;
		};
	};
	diag_log ("DEBUG: Mission Code: Sleeping....");
};