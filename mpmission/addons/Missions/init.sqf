if (isServer) then {
	// SHK_pos
    diag_log "Mission Init - SAR_AI - starting SHK_pos";
    call compile preprocessFileLineNumbers "addons\SHK_pos\shk_pos_init.sqf";
	
	// Mission System
		// Mission
	[] execVM "\z\addons\dayz_server\missions\mission_deamon.sqf";
};

if (!isDedicated) then {
	// Custom Debug
	[] execVM "extras\debug_monitor\debug_monitor.sqf";
	
	// PublicEH for Mission Updates
	"customMissionWarning" addPublicVariableEventHandler {_this select 1 execVM "addons\Missions\mission_warning.sqf"};
};

// UPSMON
call compile preprocessFileLineNumbers "addons\UPSMON\scripts\Init_UPSMON.sqf";

// run SAR_AI
[] execVM "addons\SARGE\SAR_AI_init.sqf";
