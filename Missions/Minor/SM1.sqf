//Hunting Party script by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
private ["_coords","_wait","_dummymarker"];

_wait = [600,300] call fnc_hTime;
sleep _wait;

[nil,nil,rTitleText,"A bandit hunting party has been spotted!", "PLAIN",6] call RE;

_coords = [getMarkerPos "center",0,5500,2,0,2000,0] call BIS_fnc_findSafePos;

_dummymarker = createMarker["Hunting Party", _coords];
_dummymarker setMarkerColor "ColorRed";
_dummymarker setMarkerShape "ELLIPSE";
_dummymarker setMarkerBrush "Grid";
_dummymarker setMarkerSize [150,150];

_hummer = createVehicle ["SUV_DZ",[(_coords select 0) + 25, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];

[_coords,80,4,2,1] execVM "\z\addons\dayz_server\missions\add_unit_server2.sqf";//AI Guards
sleep 1;
[_coords,80,4,2,1] execVM "\z\addons\dayz_server\missions\add_unit_server2.sqf";//AI Guards
sleep 1;
[_coords,80,4,2,1] execVM "\z\addons\dayz_server\missions\add_unit_server2.sqf";//AI Guards
sleep 1;

waitUntil{({alive _x} count (units SniperTeam)) < 1};

[nil,nil,rTitleText,"You've killed the bandits! Now loot the corpses!", "PLAIN",6] call RE;

deleteMarker _dummymarker;
SM1 = 1;
[0] execVM "\z\addons\dayz_server\missions\minor\SMfinder.sqf";
