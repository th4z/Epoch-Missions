private ["_id", "_ai_veh_pool", "_vehicle", "_velimit", "_qty", "_wait", "_mission", "_mission_info", "_isNear", "_isNearList", "_y", "_group", "_ai_groups"];

#include "mission_deamon_config.sqf"

fnc_hTime = compile preprocessFileLineNumbers "\z\addons\dayz_server\missions\misc\fnc_hTime.sqf"; //Random integer selector for mission wait time
create_mission_crates = compile preprocessFileLineNumbers "\z\addons\dayz_server\missions\modules\create_mission_crates.sqf"; //Random integer selector for mission wait time

//mission_disabled_veh = compile preprocessFile "\z\addons\dayz_server\modules\mission_loot.sqf"; //Random integer selector for mission wait time
//mission_patrol_ground_veh = compile preprocessFile "\z\addons\dayz_server\modules\mission_loot.sqf"; //Random integer selector for mission wait time


_id = 0;
_isNear = false;
_ai_groups = [];

diag_log ("DEBUG: Mission Code: Start.......");

// TODO ADD Code to Generate List of Vehicles Available to Spawn onto Server....
_ai_veh_pool = [];
{
	_vehicle = _x select 0;
	_velimit = _x select 1;
	_qty = {_x == _vehicle} count serverVehicleCounter;
	if (isNil {_qty}) then {
		diag_log format ["DEBUG: Mission Code: Vehicle: %1 None DETECTED !!!", _vehicle];
		_qty = 0;
	};
	if (_qty <= _velimit) then {
		_ai_veh_pool = _ai_veh_pool + [[_vehicle, _velimit]];
	};
	diag_log format ["DEBUG: Mission Code: Vehicle: %1: Limit: %2: Qty: %3", _vehicle, _velimit, _qty];
} forEach dynamic_ai_vehicles;


diag_log format ["DEBUG: Mission Code: AI Vehicle Pool: %1", _ai_veh_pool];

while {true} do {
	diag_log ("DEBUG: Mission Code: Waiting....");
	if (_isNear) then {
		// Shorter Wait Time, If last mission attempt aborted due to players nearby
		_wait = [1000,650] call fnc_hTime;
	} else {
		_wait = [2000,650] call fnc_hTime;
	};
	_wait = 200; //For Testing
	sleep _wait;
	_mission = active_mission_list call BIS_fnc_selectRandom;
	
	_mission_info = _mission select 0;
	
	// Check if Player is within 200 Metres...
	// Need to add check to parse & check entities are playable i.e not SARGE AI
	_isNearList = (_mission_info select 0) nearEntities ["CAManBase",200];
	_isNear = false;
	
	// Check for Players & Ignore SARGE AI
	if ((count(_isNearList)) != 0) then {
		{
			if (vehicle _x getVariable ["Sarge",0] == 0) then {
				_isNear = true;
			};
		} forEach _isNearList;
	};
	
	diag_log format ["DEBUG: Mission Code: Check Near: %1", _isNear];
	if (!_isNear) then {
		_id = _id + 1;
		// Remove Mission if its not recurring
		if !(_mission select 1) then {
			active_mission_list = active_mission_list - _mission;
		};
		diag_log format ["DEBUG: Mission Code: Start Mission: %1", _mission_info];
		_group = [_id, _mission_info] call create_mission_crates;
		_ai_groups = _ai_groups + [_group];
		diag_log format ["DEBUG: Mission Code: AI Groups: %1", _ai_groups];
		diag_log ("DEBUG: Mission Code: Mission Ended");
	};
};