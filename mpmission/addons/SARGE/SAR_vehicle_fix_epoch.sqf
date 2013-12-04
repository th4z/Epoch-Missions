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
//  UPSMon  (specific SARGE version)
//  SHK_pos 
//  
// ---------------------------------------------------------------------------------------------------------
//   SAR_vehicle_fix.sqf
//   last modified: 28.5.2013
// ---------------------------------------------------------------------------------------------------------

private ["_loop","_chk_count","_gridwidth","_markername","_triggername","_trig_act_stmnt","_trig_deact_stmnt","_trig_cond","_pos","_tmp","_sphere_alpha","_sphere_red","_sphere_green","_sphere_blue","_obj_text_string"];

if (!isServer) exitWith {}; // only run this on the server
	
_x = _this select 0;

if (isNil "SAR_VEH_COUNTER") then {
	SAR_VEH_COUNTER = 0;
};
_gridwidth = 5;	 

if (_x isKindOf "AllVehicles") then { // just do this for vehicles, not other objects like tents

	_triggername = format["SAR_veh_trig_%1",SAR_VEH_COUNTER];

	_this = createTrigger ["EmptyDetector", [0,0]];
	_this setTriggerArea [_gridwidth,_gridwidth, 0, false];
	_this setTriggerActivation ["ANY", "PRESENT", true];
	_this setVariable ["unitlist",[],true];
	
	_this setVariable ["SAR_trig_veh",_x,true];

	Call Compile Format ["SAR_veh_trig_%1 = _this",SAR_VEH_COUNTER]; 
	
	_trig_act_stmnt = format["[thislist,thisTrigger,'%1'] spawn SAR_AI_veh_trig_on_static;",_triggername];
	_trig_deact_stmnt = format["[thislist,thisTrigger,'%1'] spawn SAR_AI_veh_trig_off;",_triggername];

	_trig_cond = "{(isPlayer _x) && (vehicle _x == _x) } count thisList != count (thisTrigger getVariable['unitlist',[]]);";

	Call Compile Format ["SAR_veh_trig_%1",SAR_VEH_COUNTER] setTriggerStatements [_trig_cond,_trig_act_stmnt , _trig_deact_stmnt];

	Call Compile Format ["SAR_veh_name_%1 = _x",SAR_VEH_COUNTER]; 
	Call Compile Format ["SAR_veh_trig_%1",SAR_VEH_COUNTER] attachTo [Call Compile Format ["SAR_veh_name_%1",SAR_VEH_COUNTER],[0,0,0]];
		
	SAR_VEH_COUNTER = SAR_VEH_COUNTER + 1;

};