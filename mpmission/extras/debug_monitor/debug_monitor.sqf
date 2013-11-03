private ["_warning", "_combatlogger", "_combatlogger_timer", "_mission", "_mission_timer", "_info_combatlogger", "_rtime", "_hours", "_minutes", "_minutes2", "_humanity", "_pic", "_info_player"];
_warning = false;
_combatlogger = '';
_combatlogger_timer = -60;

_mission = '';
_mission_timer = -60;

_info_combatlogger = '';

ServerRestartTimer_hours = 0;
ServerRestartTimer_minutes = 0;

debugMonitor = true;
customMission = "";

_rtime = round(21600 - serverTime);

while {true} do {
	_rtime = round(21600 - serverTime);
	
	if ((_rtime < 300) && (!_warning)) then {
		_warning = true;
		cutText [(localize "STR_custom_5minRestart"),"PLAIN"];
	};

	if (debugMonitor) then {
		_hours = (_rtime/60/60);
		_hours = toArray (str _hours);
		_hours resize 1;
		_hours = toString _hours;
		_hours = compile _hours;
		_hours = call _hours;
		_minutes = round(_rtime/60);
		_minutes2 = _minutes - (_hours*60);
		
		//Debug Info
		_humanity =	player getVariable["humanity",0];

		_pic = (gettext (configFile >> 'CfgVehicles' >> (typeof vehicle player) >> 'picture'));
		
		if (player == vehicle player) then {
			_pic = (gettext (configFile >> 'cfgWeapons' >> (currentWeapon player) >> 'picture'));
		} else {
			_pic = (gettext (configFile >> 'CfgVehicles' >> (typeof vehicle player) >> 'picture'));
		};
		
		_info_player = 
			"<t size='1' font='Bitstream' align='Center' >%1</t><br/>
			<img size='4.75' image='%4'/><br/>
			<t size='1' font='Bitstream' align='left' color='#CC0000'>" + (localize "STR_custom_blood") + ": </t><t size='1' font='Bitstream' align='right'>%2</t><br/>
			<t size='1' font='Bitstream' align='left' color='#0066CC'>" + (localize "STR_custom_humanity") + ": </t><t size='1' font='Bitstream' align='right'>%3</t><br/>
			<br/>
			<t size='1' font='Bitstream' align='left' color='#FFBF00'>"+ (localize "STR_custom_serverrestart") + ": </t><t size='1' font='Bitstream' align='right'>%5h %6min</t><br/>
			<t size='1' font='Bitstream' align='left' color='#FFBF00'>"+ (localize "STR_custom_playersalive") + ": </t><t size='1' font='Bitstream' align='right'>%9</t><br/>
			<t size='1' font='Bitstream' align='left' color='#FFBF00'>FPS: </t><t size='1' font='Bitstream' align='right'>%8</t><br/>
			<t size='1' font='Bitstream' align='Center' color='#CC0000'>%7</t>"
			+ customMission + 
			_info_combatlogger +
			"<t size='1'font='Bitstream'align='center' color='#104E8B' >"+ (localize "STR_custom_f5toggle") + "</t><br/>
			<t size='1'font='Bitstream'align='center' color='#104E8B' >"+ (localize "STR_custom_f10toggle") + "</t><br/>";

		hintSilent parseText format 
			[_info_player,
			('' + (gettext (configFile >> 'CfgVehicles' >> (typeof vehicle player) >> 'displayName'))),
			(r_player_blood),
			round (player getVariable['humanity', 0]),
			_pic,
			_hours,
			_minutes2,
			"",
			round(diag_fps),
			0,
			"extras\debug_monitor\warning.paa",
			"extras\debug_monitor\pirates.paa",
			_combatlogger
			];
	};
	sleep 1;	
};