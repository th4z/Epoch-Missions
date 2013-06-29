//Bandit Supply Heli Crash by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
private ["_coords","_dummymarker","_chopper","_wait"];
_wait = [2000,650] call fnc_hTime;
sleep _wait;
[nil,nil,rTitleText,"A bandit supply helicopter has crash landed! Secure it and it's cargo for yourself!", "PLAIN",10] call RE;
_coords = [getMarkerPos "center",0,5500,30,0,20,0] call BIS_fnc_findSafePos;

_dummymarker = createMarker["STR_MISSION_MARKER_4", _coords];
_dummymarker setMarkerColor "ColorGreen";
_dummymarker setMarkerShape "ELLIPSE";
_dummymarker setMarkerBrush "Grid";
_dummymarker setMarkerSize [250,250];

_chopper = ["UH1H_DZ","Mi17_DZ"] call BIS_fnc_selectRandom;

_hueychop = createVehicle [_chopper,_coords,[], 0, "NONE"];
_hueychop setVariable ["Mission",1,true];
_hueychop setFuel 0.1;
_hueychop setVehicleAmmo 0.2;

_crate2 = createVehicle ["USLaunchersBox",[(_coords select 0) - 6, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate2] execVM "\z\addons\dayz_server\missions\misc\fillBoxesS.sqf";

_crate2 = createVehicle ["USLaunchersBox",[(_coords select 0) + 6, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate2] execVM "\z\addons\dayz_server\missions\misc\fillBoxesS.sqf";

_crate3 = createVehicle ["RULaunchersBox",[(_coords select 0) - 14, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate3] execVM "\z\addons\dayz_server\missions\misc\fillBoxesH.sqf";


_aispawn = [_coords,80,6,6,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [_coords,80,6,4,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [_coords,40,4,4,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;

waitUntil{{isPlayer _x && _x distance _hueychop < 10  } count playableunits > 0}; 

[nil,nil,rTitleText,"The helicopter has been taken by survivors!", "PLAIN",6] call RE;

deleteMarker _dummymarker;

SM1 = 5;
[0] execVM "\z\addons\dayz_server\missions\major\SMfinder.sqf";
