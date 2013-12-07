private ["_warning", "_rtime", "_hours", "_minutes", "_minutes2", "_humanity", "_pic", "_info_player"];
_warning = false;

customMission = "";
customMissionImage = "";
customStudyBody = "";
debugMonitor = true;

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
		
		if (player == vehicle player) then {
			_pic = (gettext (configFile >> 'cfgWeapons' >> (currentWeapon player) >> 'picture'));
		} else {
			_pic = (gettext (configFile >> 'CfgVehicles' >> (typeof vehicle player) >> 'picture'));
		};
		
		_info_player = 
			"<t size='1' font='Bitstream' align='Center' >%5</t><br/>
			<img size='4.75' image='%8'/><br/>
			<t size='1' font='Bitstream' align='left' color='#CC0000'>" + (localize "STR_custom_blood") + ": </t><t size='1' font='Bitstream' align='right'>%6</t><br/>
			<t size='1' font='Bitstream' align='left' color='#0066CC'>" + (localize "STR_custom_humanity") + ": </t><t size='1' font='Bitstream' align='right'>%7</t><br/>
			<br/>
			<t size='1' font='Bitstream' align='left' color='#FFBF00'>"+ (localize "STR_custom_serverrestart") + ": </t><t size='1' font='Bitstream' align='right'>%9h %10min</t><br/>
			<t size='1' font='Bitstream' align='left' color='#FFBF00'>"+ (localize "STR_custom_playersalive") + ": </t><t size='1' font='Bitstream' align='right'>%4</t><br/>
			<t size='1' font='Bitstream' align='left' color='#FFBF00'>FPS: </t><t size='1' font='Bitstream' align='right'>%11</t><br/>"
			+ customMission + customStudyBody +
			"<t size='1'font='Bitstream'align='center' color='#104E8B' >"+ (localize "STR_custom_f5toggle") + "</t><br/>
			<t size='1'font='Bitstream'align='center' color='#104E8B' >"+ (localize "STR_custom_f10toggle") + "</t><br/>";

		hintSilent parseText format 
			[_info_player,
			customMissionImage,
			"extras\debug_monitor\pirates.paa",
			"extras\debug_monitor\warning.paa",
			customPlayerCount,
			('' + (gettext (configFile >> 'CfgVehicles' >> (typeof vehicle player) >> 'displayName'))),
			round (r_player_blood),
			round (player getVariable['humanity', 0]),
			_pic,
			_hours,
			_minutes2,
			round(diag_fps)
			];
	};
	sleep 1;	
};