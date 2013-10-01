private ["_crate", "_crates", "_y", "_id", "_marker", "_mission_info", "_group"];
/*
[[6587.55,2411.75,0.00143909],[[6572.9,2405.32,0.00143862],[6570.58,2406.92,0.00143862],[6567.86,2408.94,0.00143862],[6584.31,2406.71,0.00143862]],1,6,["patrol"],["USVehicleBox","USVehicleBox","USLaunchersBox","USVehicleBox"],["Random","Random","Random","Random"],"Bandits Have Been Spotted at Cherno! Check your map for the location!"]"
*/

diag_log format ["DEBUG: Create Mission Code: _this: %1", _this];
_id = _this select 0;
_mission_info = _this select 1;

_crates = [];


// Start Mission

[nil,nil,rTitleText,(_mission_info select 7), "PLAIN",10] call RE;
MCoords = (_mission_info select 0);
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
_marker = createMarker [("SAR_mission_" + str(_id)), (_mission_info select 0)];
_marker setMarkerShape "RECTANGLE";
_marker setMarkeralpha 0;
_marker setMarkerType "Flag";
_marker setMarkerBrush "Solid";
_marker setMarkerSize [200,200];
// Generated Global Varaible Name for SARGE UPSMON. To avoid errors when mission = done, but AI is still alive.
// http://forums.bistudio.com/showthread.php?126760-dynamic-object-names-with-part-of-name-provided-by-a-variable
missionNamespace setVariable ["SAR_mission_" + str(_id), _marker];  

_group = [missionNameSpace getVariable ("SAR_mission_" + str(_id)), 3, _mission_info select 2, _mission_info select 3, (_mission_info select 4) call BIS_fnc_selectRandom ,false] call SAR_AI;

		
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

_group