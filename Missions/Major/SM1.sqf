//Weapons Cache by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)

private ["_coords","_dummymarker","_wait"];
_wait = [2000,650] call fnc_hTime;
sleep _wait;

[nil,nil,rTitleText,"Bandits have discovered a weapons cache! Kill them and secure the weapons for yourself!", "PLAIN",10] call RE;

_coords = [getMarkerPos "center",0,5500,30,0,2000,0] call BIS_fnc_findSafePos;

_dummymarker = createMarker["STR_MISSION_MARKER_1", _coords];
_dummymarker setMarkerColor "ColorBlack";
_dummymarker setMarkerShape "ELLIPSE";
_dummymarker setMarkerBrush "Grid";
_dummymarker setMarkerSize [250,250];

_hummer = createVehicle ["HMMWV_DZ",[(_coords select 0) + 10, (_coords select 1) - 20,0],[], 0, "CAN_COLLIDE"];
_hummer = createVehicle ["HMMWV_DZ",[(_coords select 0) + 20, (_coords select 1) - 10,0],[], 0, "CAN_COLLIDE"];
_hummer = createVehicle ["SUV_DZ",[(_coords select 0) + 30, (_coords select 1) + 10,0],[], 0, "CAN_COLLIDE"];

_crate = createVehicle ["USVehicleBox",_coords,[], 0, "CAN_COLLIDE"];
[_crate] execVM "\z\addons\dayz_server\missions\misc\fillBoxes.sqf";

_aispawn = [_coords,80,6,6,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [_coords,80,6,6,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [_coords,40,4,4,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [_coords,40,4,4,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;

waitUntil{{isPlayer _x && _x distance _crate < 5  } count playableunits > 0}; 

[nil,nil,rTitleText,"The weapons cache is under survivor control!", "PLAIN",6] call RE;

deleteMarker _dummymarker;
SM1 = 1;
[0] execVM "\z\addons\dayz_server\missions\major\SMfinder.sqf";
