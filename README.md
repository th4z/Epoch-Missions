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

	if (isServer) then {
	
Change to
	if (isServer) then {
		Custom_Plot_Poles = [];

Look for 

	_serverMonitor = 	[] execVM "\z\addons\dayz_server\system\server_monitor.sqf";

Change to
	_serverMonitor = 	[] execVM "\z\addons\dayz_server\system\server_monitor.sqf";
	
	// Mission System
		// Mission
	[] execVM "\z\addons\dayz_server\missions\mission_deamon.sqf";


<h5>STEP 3 -- SARGE AI INSTALL</h5>

Read Instructions at
https://github.com/Swiss-Sarge/SAR_AI-1.5.0

Changes to Sarge are

Files provided are custom/altered Sarge files that will save the AI vehicles to the database.
It also returns the group for when it spawns AI Land Vehicles.

Contains fix for AI suriviors bloodbag players
Also contains invisible AI workaround aswell


<h5>Notes</h5>
 
 * Yes i will write more here when i get a chance

 * Mission & AI Vehicles are saved to Hive
 
 * Mission Locations are near Roads / Buildings
 
 * Missions will work with any map basicly. Using same code as epoch for spawning vehicle locations.
 
 * Edit the debug monitor code to suit your server... One provided is an example not all features are provided
