private ["_bandit_missions", "_null"];
diag_log ("DEBUG: Mission Code: Start.......");

#include "config.sqf"

fnc_hTime = compile preprocessFileLineNumbers "\z\addons\dayz_server\missions\misc\fnc_hTime.sqf"; //Random integer selector for mission wait time
call compile preprocessFileLineNumbers "\z\addons\dayz_server\missions\mission_functions.sqf";

mission_id = 0;
mission_ai_groups = [];

_bandit_missions = [];

_null = [] spawn mission_cleaner;

sleep 300;

for "_x" from 1 to num_bandit_missions do {
	_bandit_missions = _bandit_missions + [[] spawn mission_spawn];
};	

while {true} do {
	diag_log ("DEBUG: Mission Code: Waiting....");
	
	sleep [1500,650] call fnc_hTime;
	//sleep 180;
	{
		if (scriptDone _x) then {
			if ((random 10) > 6) exitWith {
				_x = [] spawn mission_spawn;
			};
		};
	} forEach _bandit_missions;
};