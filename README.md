Mission System for DayZ Epoch (by Torndeco)
=============
Original code by <a href="https://github.com/lazyink/DayZ-Missions">Lazyink</a>, <a href="https://github.com/theszerdi">TheSzerdi</a>, Falcyn and TAW_Tonic.


SARGE AI code by  <a href="https://github.com/Swiss-Sarge/SAR_AI-1.5.0">Swiss-Sarge</a>

=============
<h5>Pre-Install Instructions </h5>

If u already have Sarge Installed on your Server.

Edit your mpmission/init.sqf & remove the following lines

```
call compile preprocessFileLineNumbers "addons\UPSMON\scripts\Init_UPSMON.sqf";
 
call compile preprocessFileLineNumbers "addons\SHK_pos\shk_pos_init.sqf";
 
[] execVM "addons\SARGE\SAR_AI_init.sqf";

```

=============
<h5>Install Instructions </h5>


<h6>Step 1</h6>
Copy dayz_server/*  to your server files

Copy mpmission/* to your mission files

<h6>Step 2</h6>
Edit your mpmission/init.sqf

Look for
```
  if (isServer) then {
```  
Add
```
	  Custom_Plot_Poles = [];
```	
So it looks like
```
  if (isServer) then {
	Custom_Plot_Poles = [];
	SAR_AI_VEH_EPOCH_FIX = false; // Expermential  (Original SARGE FIX, didnt run on vehicles bought at traders or spawned after server start)
	SAR_AI_VEH_FIX = compile preprocessFileLineNumbers "addons\SARGE\SAR_vehicle_fix_epoch.sqf";
```

At the very bottom add 
```
  // Missions + Sarge AI
  execVM "addons\Missions\init.sqf";
```
<h6>Step 3</h6>
Edit your mpmission/description.ext

Add to the very end of file
```
  #include "addons\SARGE\SAR_define.hpp"
```

<h6>Step 4</h6>
To enable the F10 button for debug monitor
Edit your custom compiles.sqf
Look for 
```
dayz_spaceInterrupt = {
............
		_handled
}
```

Change it to

```
dayz_spaceInterrupt = {
............

		if (_dikCode == 0x44) then {
			if (debugMonitor) then {
				debugMonitor = false;
				hintSilent "";
			} else {
				debugMonitor = true;
			};
		};
		
...........
    _handled
};
```


=============
<h5>Optional Steps</h5>

<h6>Sarge AI + to reduce AI around plotpoles</h6>
This code will just stop AI from patroling within 100 metres of a plotpole + deciding to patrol inside a building near a plotpole.
This wont stop AI from getting drawn in range of plotpole by zombies, or ai spotting a player + chasing a player in range of plotpole.
Literally just tell your players it reduces chances of AI harassing them @ thier base.
Anyway

Copy optional/plotpoles/dayz_server/* to your server files

Edit your dayz_server/init/server_functions.sqf

  Look for
```
  	server_deaths = 			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerDeaths.sqf";
```	
  Change to
```  
  	server_deaths = 			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerDeaths.sqf";
  	server_add_plotpole_list = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_add_plotpole_list.sqf";
  	server_delete_plotpole_list = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_delete_plotpole_list.sqf";
```

<h6>Debug Monitor</h6>
Well techincal Optional, its a main feature of this mission system.
If u have it disabled, or have alter your own debug monitor u can remove all the files located @

```
  dayz_server/extras/debug_monitor
```

=============
<h5>List of some SARGE Code Changes</h5>

Removed most of debug code, can be added back in, but there is no need for the code for 90% of servers.
Can be added back in very easily using a program like winmerge to compare sarge files with original.

New Sarge Group  "Bandit Missions", this will allow server admins to make mission ai wear different skins or have different loadouts from wandering AI.
Please note the Bandits + Banit Missions AI are still the same team + work together, get the same humanity gain for shoting

Sarge AI now will spawn in vehicle turrets (should work with most of epoch vehicles). Send bug reports if u notice one not working or have errors

Expermential Vehicle Fix for Epoch. Original Fix didnt run on vehicles bought after server startup or spawned at missions.


=============
<h5>List of Planned Changes</h5>
More custom mission types
Hopefully a new mission ai for a hunter AI (awaiting for permission)


=============
<h5>Important Notes</h5>

If u have an existing Sarge Setup, don't forget to remove the code starting sarge etc, in your init.sqf.
This is all done now in addons\Missions\init.sqf to make setup easier.

If u are updating from a previous version
Note i have removed the need for a custom publicEH.sqf and moved / renamed some of the debug monitor files around.

Also if u are using a custom debug monitor, there is a new global mission image variable, look @ debug monitor provided
and make the needed changes.
