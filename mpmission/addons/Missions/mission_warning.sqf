private ["_text", "_vehicle_spawn", "_mission_warning_debug", "_marker_name", "_marker_pos", "_vehicle", "_nearestCity"];
waitUntil {sleep 1; customMission == ''};

_mission_type = _this select 0;
_mission_warning_debug = _this select 1;

_marker_name = _this select 2;
_marker_pos  = _this select 3;

_vehicle_spawn = _this select 4;
_vehicle = _this select 5;

_text = "";
_text2 = "";

_nearestCity = nearestLocations [_marker_pos, ["NameCityCapital","NameCity","NameVillage","NameLocal"],1000];

if ((count _nearestCity) > 0) then {
	if (((text(_nearestCity select 0)) == "Center") && ((count _nearestCity) > 1)) then {
		_text2 = (text (_nearestCity select 1));
	} else {
		_text2 = (text (_nearestCity select 0));
	};
};

if (_vehicle_spawn) then {
	_text = "Bandits Have Crashed";
} else {
	switch (_mission_type) do {
		case "Road":
		{
			_text = "Bandits have setup a Camp";
		};
		case "Building":
		{
			_text = "Bandits are Looting";
		};
		case "Open Area":
		{
			_text = "Bandits have setup Camp";
		};
		case "CrashCJ":
		{
			_text = "Bandits have shot down a Cargo Plane";
		};
	};
};



if (_mission_warning_debug) then {
	if (_vehicle_spawn) then {
		customMissionImage = (gettext (configFile >> 'CfgVehicles' >> _vehicle >> 'picture'));
		customMission = "<br/>
						<img align='Center' size='4.75' image='%1'/><br/>
						<t size='1' font='Bitstream' align='left' color='#CC0000'>" + _text + "</t><br/>
						<t size='1' font='Bitstream' align='left' color='#CC0000'>" + _text2 + "</t><br/>";
	} else {
		customMission = "<br/>
						<img align='Center' size='4.75' image='%2'/><br/>
						<t size='1' font='Bitstream' align='left' color='#CC0000'>" + _text + "</t><br/>
						<t size='1' font='Bitstream' align='left' color='#CC0000'>" + _text2 + "</t><br/>";
	};
	sleep 30;
	customMission = '';
	customMissionImage = '';
} else {
	titleText [(_text + " " + _text2), "PLAIN",6];
};