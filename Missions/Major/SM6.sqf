//Medical Crate by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)

private ["_coords","_dummymarker","_wait"];
_wait = [2000,650] call fnc_hTime;
sleep _wait;

[nil,nil,rTitleText,"A medical supply crate has been secured by bandits! Kill them all to get the supplies!", "PLAIN",10] call RE;

_coords = [getMarkerPos "center",0,5500,30,0,2000,0] call BIS_fnc_findSafePos;

_dummymarker = createMarker["STR_MISSION_MARKER_7", _coords];
_dummymarker setMarkerColor "ColorGreen";
_dummymarker setMarkerShape "ELLIPSE";
_dummymarker setMarkerBrush "Grid";
_dummymarker setMarkerSize [250,250];

_hummer = createVehicle ["HMMWV_DZ",[(_coords select 0) + 10, (_coords select 1) - 10,0],[], 0, "CAN_COLLIDE"];
_hummer = createVehicle ["HMMWV_DZ",[(_coords select 0) + 20, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];

_crate = createVehicle ["USVehicleBox",[(_coords select 0) - 1, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate] execVM "\z\addons\dayz_server\missions\misc\fillBoxesM.sqf";

_crate2 = createVehicle ["USLaunchersBox",[(_coords select 0) - 8, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate2] execVM "\z\addons\dayz_server\missions\misc\fillBoxesS.sqf";

_aispawn = [_coords,80,6,6,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [_coords,80,6,6,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [_coords,40,4,4,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;

waitUntil{{isPlayer _x && _x distance _crate < 5  } count playableunits > 0}; 

[nil,nil,rTitleText,"The medical crate is under survivor control!", "PLAIN",6] call RE;

deleteMarker _dummymarker;
SM1 = 1;
[0] execVM "\z\addons\dayz_server\missions\major\SMfinder.sqf";
