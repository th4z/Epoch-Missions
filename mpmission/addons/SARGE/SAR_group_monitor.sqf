// =========================================================================================================
//  SAR_AI - DayZ AI library
//  Version: 1.5.0 
//  Author: Sarge (sarge@krumeich.ch) 
//
//		Wiki: to come
//		Forum: http://opendayz.net/#sarge-ai.131
//		
// ---------------------------------------------------------------------------------------------------------
//  Required:
//  UPSMon  (special SARGE version)
//  SHK_pos 
//  
// ---------------------------------------------------------------------------------------------------------
//   SAR_group_monitor.sqf
//   last modified: 28.5.2013
// ---------------------------------------------------------------------------------------------------------


private ["_allgroups","_running","_sleeptime","_count_friendly_groups","_count_unfriendly_groups","_debugstring"];

if (!isServer) exitWith {}; // only run this on the server

_running = true;
_sleeptime = 5;


while {_running} do {

    _allgroups = allgroups;

    _count_friendly_groups = {side _x == SAR_AI_friendly_side} count _allgroups;
    _count_unfriendly_groups = {side _x == SAR_AI_unfriendly_side} count _allgroups;

    if(_count_friendly_groups > 120) then {

        diag_log format["SARGE AI: WARNING - more than 120 friendly AI groups active. Consider decreasing your configured AI survivor and soldier groups. Number of active groups: %1.",_count_friendly_groups];
        SAR_MAX_GRP_WEST_SPAWN = true;
    } else {
        SAR_MAX_GRP_WEST_SPAWN = false;
    };

    if(_count_unfriendly_groups > 120) then {
    
        diag_log format["SARGE AI: WARNING - more than 120 unfriendly AI groups active. Consider decreasing your configured AI bandit groups. Number of active groups: %1.",_count_unfriendly_groups];
        SAR_MAX_GRP_EAST_SPAWN = true;
        
    } else {
        SAR_MAX_GRP_EAST_SPAWN = false;    
    };
    
    sleep _sleeptime;

};