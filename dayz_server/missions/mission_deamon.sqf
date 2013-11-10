private ["_bandit_missions", "_null", "_wait", "_handle"];
diag_log ("DEBUG: Mission Code: Start.......");

#include "config.sqf"

fnc_hTime 		 = compile preprocessFileLineNumbers "\z\addons\dayz_server\missions\misc\fnc_hTime.sqf"; //Random integer selector for mission wait time
call compile preprocessFileLineNumbers "\z\addons\dayz_server\missions\mission_functions.sqf";

mission_id = 0;
mission_ai_groups = [];

_bandit_missions = [];

_null = [] spawn mission_cleaner;

sleep 300;

for "_x" from 1 to missions_max_number do {
	_handle = [] spawn mission_spawn;
	_bandit_missions = _bandit_missions + [_handle];
};	

while {true} do {
	diag_log ("DEBUG: Mission Code: Waiting....");
	
	_wait = [1500,650] call fnc_hTime;
	//_wait = 180;
	sleep _wait;

	{
		diag_log format ["DEBUG MISSIONS: _x: %1 scriptDone: %2", _x, (scriptDone _x)];
		if (scriptDone _x) then {
			if ((random 10) > 4) exitWith {
				_x = [] spawn mission_spawn;
			};
		};
	} forEach _bandit_missions;
	diag_log format ["DEBUG MISSIONS: _bandit_missions: %1", _bandit_missions];
};
