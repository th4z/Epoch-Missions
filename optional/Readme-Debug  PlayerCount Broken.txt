If your anti-hack is stopping your count playableUnits  working in debug.
Now in your debug use the variable  customPlayerCount

Add the following to the end of the files located @

dayz_server/compile/

Edit
server_playerSetup.sqf

Change End of file to
---------------------
customPlayerCount = (count playableUnits);
publicVariable "customPlayerCount";
call mission_sync_markers;

PVDZE_plr_Login = nil;
PVDZE_plr_Login2 = nil;
-----------------

Edit
server_onPlayerDisconnect.sqf
server_playerDied.sqf

Add to End of files
---------------------------
customPlayerCount = count playableUnits;
publicVariable "customPlayerCount";