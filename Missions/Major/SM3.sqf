//Medical Supply Camp by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)

private ["_coords","_dummymarker","_base","_wait"];
_wait = [2000,650] call fnc_hTime;
sleep _wait;
[nil,nil,rTitleText,"Bandits have set up a medical re-supply camp! Secure it for yourself!", "PLAIN",10] call RE;

_coords = [getMarkerPos "center",0,5500,50,0,20,0] call BIS_fnc_findSafePos;

_dummymarker = createMarker["STR_MISSION_MARKER_3", _coords];
_dummymarker setMarkerColor "ColorGreen";
_dummymarker setMarkerShape "ELLIPSE";
_dummymarker setMarkerBrush "Grid";
_dummymarker setMarkerSize [250,250];

_baserunover = createVehicle ["land_fortified_nest_big",[(_coords select 0) - 20, (_coords select 1) - 10,-0.2],[], 0, "CAN_COLLIDE"];
_baserunover2 = createVehicle ["Land_Fort_Watchtower",[(_coords select 0) - 10, (_coords select 1) + 10,-0.2],[], 0, "CAN_COLLIDE"];
_hummer = createVehicle ["HMMWV_DZ",[(_coords select 0) + 25, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];

_crate = createVehicle ["USVehicleBox",[(_coords select 0) + 5, (_coords select 1),0],[], 0, "CAN_COLLIDE"];
[_crate] execVM "\z\addons\dayz_server\missions\misc\fillBoxesM.sqf";

_crate2 = createVehicle ["USLaunchersBox",[(_coords select 0) + 12, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate2] execVM "\z\addons\dayz_server\missions\misc\fillBoxesS.sqf";

_aispawn = [_coords,80,6,3,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [_coords,40,4,3,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;
_aispawn = [_coords,40,4,3,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 5;

waitUntil{{isPlayer _x && _x distance _baserunover < 10  } count playableunits > 0}; 

[nil,nil,rTitleText,"Survivors have taken control of the camp and medical supplies.", "PLAIN",6] call RE;

deleteMarker _dummymarker;

SM1 = 1;
[0] execVM "\z\addons\dayz_server\missions\major\SMfinder.sqf";
