//Hummer Wreck by lazyink (Full credit for code to TheSzerdi & TAW_Tonic)
private ["_coords","_itemType","_itemChance","_weights","_index","_iArray","_num","_nearby","_checking","_people","_wait","_dummymarker"];
_wait = [600,300] call fnc_hTime;
sleep _wait;
[nil,nil,rTitleText,"A Humvee has crashed! Kill any survivors and secure the loot!", "PLAIN",10] call RE;

_coords =  [getMarkerPos "center",0,4000,10,0,2000,0] call BIS_fnc_findSafePos;

_dummymarker = createMarker["Humvee Wreck", _coords];
_dummymarker setMarkerColor "ColorRed";
_dummymarker setMarkerShape "ELLIPSE";
_dummymarker setMarkerBrush "Grid";
_dummymarker setMarkerSize [125,125];

_humveecrash = createVehicle ["HMMWVwreck",_coords,[], 0, "CAN_COLLIDE"];
_humveecrash setVariable ["Mission",1,true];

_crate2 = createVehicle ["USLaunchersBox",[(_coords select 0) - 6, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate2] execVM "\z\addons\dayz_server\missions\misc\fillBoxesS.sqf";

_crate3 = createVehicle ["RULaunchersBox",[(_coords select 0) - 14, _coords select 1,0],[], 0, "CAN_COLLIDE"];
[_crate3] execVM "\z\addons\dayz_server\missions\misc\fillBoxesH.sqf";

[_coords,40,4,3,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 1;
[_coords,40,4,3,1] execVM "\z\addons\dayz_server\missions\add_unit_server.sqf";//AI Guards
sleep 1;


waitUntil{{isPlayer _x && _x distance _crate2 < 5  } count playableunits > 0}; 

deleteMarker _dummymarker;

[nil,nil,rTitleText,"The crash site has been secured by survivors!", "PLAIN",6] call RE;

SM1 = 5;
[0] execVM "\z\addons\dayz_server\missions\minor\SMfinder.sqf";
