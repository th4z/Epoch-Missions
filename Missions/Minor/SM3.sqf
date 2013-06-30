//Bandit Stash House by lazyink (Full credit for code to TheSzerdi & TAW_Tonic)
private ["_coords","_iArray","_nearby","_index","_num","_itemType","_itemChance","_weights","_wait","_dummymarker","_nul"];
_wait = [600,300] call fnc_hTime;
sleep _wait;
[nil,nil,rTitleText,"A group of bandits have set up a stash house!", "PLAIN",10] call RE;

_coords =  [getMarkerPos "center",0,4000,10,0,20,0] call BIS_fnc_findSafePos;

_dummymarker = createMarker["Stash House", _coords];
_dummymarker setMarkerColor "ColorRed";
_dummymarker setMarkerShape "ELLIPSE";
_dummymarker setMarkerBrush "Grid";
_dummymarker setMarkerSize [175,175];

_baserunover = createVehicle ["Land_HouseV_1I3",[(_coords select 0) +2, (_coords select 1)+5,-0.3],[], 0, "CAN_COLLIDE"];
_baserunover2 = createVehicle ["Land_hut06",[(_coords select 0) - 10, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_baserunover3 = createVehicle ["Land_hut06",[(_coords select 0) - 7, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_hummer = createVehicle ["HMMWV_DZ",[(_coords select 0) + 10, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_hummer1 = createVehicle ["HMMWV_DZ",[(_coords select 0) + 15, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_hummer2 = createVehicle ["SUV_DZ",[(_coords select 0) - 25, (_coords select 1) - 5,0],[], 0, "CAN_COLLIDE"];
_hummer3 = createVehicle ["SUV_DZ",[(_coords select 0) + 25, (_coords select 1) - 15,0],[], 0, "CAN_COLLIDE"];

_baserunover setVariable ["Mission",1,true];
_baserunover2 setVariable ["Mission",1,true];
_baserunover3 setVariable ["Mission",1,true];
_hummer setVariable ["Mission",1,true];
_hummer1 setVariable ["Mission",1,true];
_hummer2 setVariable ["Mission",1,true];
_hummer3 setVariable ["Mission",1,true];

_crate = createVehicle ["USVehicleBox",[(_coords select 0) - 3, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate] execVM "\z\addons\dayz_server\missions\misc\fillBoxes.sqf";



[[(_coords select 0) - 20, (_coords select 1) - 15,0],40,4,2,0] execVM "\z\addons\dayz_server\missions\add_unit_server2.sqf";//AI Guards
sleep 3;
[[(_coords select 0) + 20, (_coords select 1) + 15,0],40,4,2,0] execVM "\z\addons\dayz_server\missions\add_unit_server2.sqf";//AI Guards
sleep 3;



waitUntil{{isPlayer _x && _x distance _baserunover < 10  } count playableunits > 0}; 

[nil,nil,rTitleText,"The stash house is under survivor control!", "PLAIN",6] call RE;

deleteMarker _dummymarker;

SM1 = 1;
[0] execVM "\z\addons\dayz_server\missions\minor\SMfinder.sqf";
