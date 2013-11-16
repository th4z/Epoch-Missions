SARGE-AI Mission System for DayZ Epoch
=============
Original code by <a href="https://github.com/lazyink/DayZ-Missions">Lazyink</a>, <a href="https://github.com/theszerdi">TheSzerdi</a>, Falcyn and TAW_Tonic.

<h5>This has only been barely tested on Epoch</h5>  

<h5>Install Files </h5>

Copy dayz_server/*  to your server files

Copy mpmission/* to your mission files



<h5>STEP 1 -- ENABLE DEBUG MONITOR + CODE FOR MARKERS</h5>

Edit your mpmission/init.sqf
Look for

	//Run the player monitor
	_id = player addEventHandler ["Respawn", {_id = [] spawn player_death;}];
	_playerMonitor = 	[] execVM "\z\addons\dayz_code\system\player_monitor.sqf";
	_void = [] execVM "R3F_Realism\R3F_Realism_Init.sqf";

	
add

		// Custom Debug
	[] execVM "extras\debug_monitor\debug_monitor.sqf";

	

Look for

 call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";	

Change it to

 call compile preprocessFileLineNumbers "fixes\init\publicEH.sqf";	



<h5>STEP 2 -- ENABLE MISSIONS</h5>

Edit your mpmission/init.sqf
Look for 

	_serverMonitor = 	[] execVM "\z\addons\dayz_server\system\server_monitor.sqf";

Add

	// Mission System
		// Mission
	[] execVM "\z\addons\dayz_server\missions\mission_deamon.sqf";


<h5>STEP 3 -- SARGE AI OPTIONAL TWEAKS</h5>

Saving SARGE AI Helis to Hive
This way if a player captures an AI Heli it will stay after server restart.


Look for
// create the vehicle
Change the code to

// create the vehicle
_vehicle = (SAR_heli_type call SAR_fnc_selectRandom);
_position = [(_rndpos select 0) + 10, _rndpos select 1, 80];
_heli = createVehicle [_vehicle, _position, [], 0, "FLY"];
_dir = round(random 180);
_heli setpos _position;
_objPosition = getPosATL _heli;
[_heli,[_dir,_objPosition],_vehicle,false,"0"] call server_publishVeh;
_heli setFuel 1;
_heli setVariable ["Sarge",1,true];
_heli engineon true; 
//_heli allowDamage false;
_heli setVehicleAmmo 1;

Thats it nice & simple

<h5>Notes</h5>

 * U need to have SARGE AI setup & working
 
 * Missions are very basic atm
 
 * Yes i will write more here when i get a chance

 * Mission Vehicles are saved to Hive
 
 * Mission Locations are near Roads / Buildings
 
 * Edit the debug monitor code to suit your server... One provided is an example not all features are provided
