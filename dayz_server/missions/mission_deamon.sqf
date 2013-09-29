private ["_wait","_mission","_mission_info","_mission_pos","_isNear", "_isNearList", "_y"];

#include "mission_deamon_config.sqf"

_id = 0;
_isNear = false;
diag_log ("Mission Start.......");

while {true} do {
	/*
	if (_isNear) then {
		_wait = [1000,650] call fnc_hTime;
	} else {
		_wait = [2000,650] call fnc_hTime;
	};
	*/
	_wait = 200;
	sleep _wait;
	_mission = active_mission_list call BIS_fnc_selectRandom;
	
	_mission_info = _mission select 0;
	_mission_pos = _mission_info select 0;
	
	// Check if Player is within 200 Metres...
	// Need to add check to parse & check entities are playable i.e not SARGE AI
	_isNearList = _mission_pos nearEntities ["CAManBase",200];
	_isNear = false;
	
	// Check for Players & Ignore SARGE AI
	if ((count(_isNearList)) != 0) then {
		{
			if (vehicle _x getVariable ["Sarge",0] == 0) then {
				_isNear = true;
			};
		} forEach _isNearList;
	};
	
	
	if (!_isNear) then {
		_crates = [];

		// Remove Mission if its not recurring
		if !(_mission select 1) then {
			active_mission_list = active_mission_list - _mission;
		};
		
		// Start Mission
		
		[nil,nil,rTitleText,(_mission_info select 7), "PLAIN",10] call RE;
		MCoords = _mission_pos;
		publicVariable "MCoords";
		[] execVM "debug\addmarkers75.sqf";
		
		// Spawn Crates
		_y = -1;
		{
			_y = _y + 1;
			//TODO: Add check that loot position is clear of objects i.e vehicles ???
			_crate = createVehicle [(_mission_info select 5) select _y, _x, [], 0, "CAN_COLLIDE"];
			[_crate, (_mission_info select 6) select _y] execVM "\z\addons\dayz_server\missions\misc\fillBoxes.sqf";
			_crate setVariable ["Sarge",1,true];  // Stop Server Cleanup Killing Box
			_crates = _crates + [_crate];
		} forEach (_mission_info select 1);
		
		
		// Spawn SARGE AI
		// 		Create Dynamic SARGE MARKER
		_id = _id + 1;
		_marker = createMarker [("SAR_mission_" + str(id)), _mission_pos];
		_marker setMarkerShape "RECTANGLE";
		_marker setMarkeralpha 0;
		_marker setMarkerType "Flag";
		_marker setMarkerBrush "Solid";
		_marker setMarkerSize [300,300];
		// Generated Global Varaible Name for SARGE UPSMON. To avoid errors when mission = done, but AI is still alive.
		// http://forums.bistudio.com/showthread.php?126760-dynamic-object-names-with-part-of-name-provided-by-a-variable
		missionNamespace setVariable ["SAR_mission_" + str(_id), _marker];  
		
		[missionNameSpace getVariable ("SAR_mission_" + str(_id)), 3, _mission_info select 2, _mission_info select 3, (_mission_info select 4) call BIS_fnc_selectRandom ,false] call SAR_AI;
		
				
		// Wait Unit  Player Approaches First Crate or  Mission Times Out
		_timeout = time + 1800;
		if (count _crates > 0) then {
			waitUntil{({isPlayer _x && _x distance (_crates select 0) < 10  } count playableunits > 0) || time > _timeout};
		} else {
			waitUntil{time > _timeout};
		};
		
		// Wait 5 mins & remove Mission Marker from Players
		sleep 300;
		[] execVM "debug\remmarkers75.sqf";
		MCoords = 0;
		publicVariable "MCoords";
		
		// Wait another 5 mins & remove Sarge Variable so server can cleanup crates
		sleep 300;
		{
			_x setVariable ["Sarge",nil];
		} forEach _crates;		
	};
};