private ["_bandit_missions", "_null", "_wait", "_handle"];
diag_log ("DEBUG: Mission Code: Start.......");

#include "config.sqf"

fnc_hTime = compile preprocessFileLineNumbers "\z\addons\dayz_server\missions\misc\fnc_hTime.sqf"; //Random integer selector for mission wait time
call compile preprocessFileLineNumbers "\z\addons\dayz_server\missions\mission_functions.sqf";

mission_id = 0;
mission_ai_groups = [];

_bandit_missions = [];

_null = [] spawn mission_cleaner;

sleep 300;

for "_x" from 1 to mission_max_number do {
	_handle = [] spawn mission_spawn;
	_bandit_missions = _bandit_missions + [_handle];
};	

diag_log format ["DEBUG: Mission Code: Max Missions %1", (count _bandit_missions)];
while {true} do {
	_wait = [1500,650] call fnc_hTime;
	//_wait = 180;
	sleep _wait;
	if ((diag_fps) > 10) then {
		{
			diag_log format ["DEBUG: Mission Code: Handle: %1", _x];
			if (scriptDone _x) then {
				diag_log ("DEBUG: Mission Code: Spawn Check ");
				if ((random 10) > 2) exitWith {
					diag_log ("DEBUG: Mission Code: Spawn");
					_x = [] spawn mission_spawn;
				};
			} else { 
				diag_log ("DEBUG: Mission Code: Still Running");
			};
		} forEach _bandit_missions;
	};
	diag_log ("DEBUG: Mission Code: Sleeping....");
};