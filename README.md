DayZChernarus-Missions by lazyink
=============
Original code by TheSzerdi

<h3>This has only been tested on Chernarus (1.7.7.1).</h3>  

 * Before installing you must first customize the fillboxes SQF's inside the MISC folder and the NPC's load-outs in the addunitserver SQF's. 
 
 * If you leave the script as is, you MUST update your BE filters with the attached files.


<h3>Installation</h3>

<b>server.pbo</b>

 * Copy the Mission folder to the root of the server PBO

 * Open <b>server_functions.sqf</b>

	<i>Find:</i>

	fn_bases = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\fn_bases.sqf";
	
	<i>Insert after:</i>
	
	fnc_hTime = compile preprocessFile "\z\addons\dayz_server\Missions\misc\fnc_hTime.sqf"; //Random integer selector for mission wait time
	
	<i>Find:</i>
	
	dayz_recordLogin = {
	private["_key"];
	_key = format["CHILD:103:%1:%2:%3:",_this select 0,_this select 1,_this select 2];
	_key call server_hiveWrite;
	};
	
	<i>Insert after:</i>
	
	if (isServer) then { 
	SMarray = ["SM1","SM2","SM3","SM4","SM5","SM6"];
    [] execVM "\z\addons\dayz_server\missions\Major\SMfinder.sqf"; //Starts major mission system
    SMarray2 = ["SM1","SM2","SM3","SM4","SM5","SM6"];
    [] execVM "\z\addons\dayz_server\missions\Minor\SMfinder.sqf"; //Starts minor mission system
	};

 * Open <b>server_updateObject.sqf</b>
	
	<i>Find:</i>
	
    //force fail
    _objectID = "0";
    _uid = "0";
	};
	
	<i>Insert after:</i>
	
	if (_object getVariable "Mission" == 1) exitWith {};
	

 * Open <b>server_cleanup.fsm</b>
 
	<i>Find:</i>
 
	if(vehicle _x != _x && !(vehicle _x in _safety) && (typeOf vehicle _x) != ""ParachuteWest"") then {" \n

	<i>Insert after:</i>
	
    if(vehicle _x != _x && (vehicle _x getVariable [""Mission"",0] != 1) && !(vehicle _x in _safety) && (typeOf vehicle _x) != ""ParachuteWest"") then {" \n

	
IF YOU HAVE SARGE AI INSTALLED YOU NEED TO CHANGE THE VEHICLE VARIABLE IN EACH MISSION TO "SARGE" INSTEAD OF USING "MISSIONS" (Not tested with SARGE AI, may be incompatible.)


<b>mission.pbo:</b>

The AI require faction settings. If you have SARGE AI you're good to go. Otherwise add faction.sqf to the root of the mission.pbo and add this line to the end of your init.sqf:

    [] execVM "faction.sqf";
	

	

