private ["_isNear", "_null", "_wait"];
diag_log ("DEBUG: Mission Code: Start.......");

#include "config\config.sqf"

fnc_hTime = compile preprocessFileLineNumbers "\z\addons\dayz_server\missions\misc\fnc_hTime.sqf"; //Random integer selector for mission wait time
call compile preprocessFileLineNumbers "\z\addons\dayz_server\missions\mission_functions.sqf";

mission_id = 0;
mission_ai_groups = [];


_isNear = false;
_null = [] spawn mission_cleaner;

while {true} do {
	diag_log ("DEBUG: Mission Code: Waiting....");
	if (_isNear) then {
		_wait = [1000,650] call fnc_hTime;
	} else {
		_wait = [2000,650] call fnc_hTime;
	};

	//sleep _wait;
	sleep 180;

	//_null = [] spawn mission_spawn;
	_null = [] call mission_spawn;
};