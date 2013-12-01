private ["_id", "_text", "_position", "_marker", "_vehicle_spawn", "_vehicle"];
waitUntil {sleep 1; customMission == ''};

_mission_status = _this select 0;  // start or stop status for mission
_mission_warning_debug = _this select 1;

if (_mission_status == "start") then {

	_marker_name = _this select 2;
	_marker_pos  = _this select 3;
	_vehicle_spawn = _this select 4;
	_vehicle = _this select 5;
	_text = _this select 6;

	// Start Mission
	_marker = createMarkerLocal[_marker_name, _marker_pos];
	if (_vehicle_spawn) then {
		_marker setMarkerColorLocal "ColorBlue";
	} else {
		_marker setMarkerColorLocal "ColorRed";
	};
	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerBrushLocal "Grid";
	_marker setMarkerSizeLocal [300,300];

	_nearestCity = nearestLocations [_marker_pos, ["NameCityCapital","NameCity","NameVillage","NameLocal"],1000];
	diag_log format ["DEBUG MISSIONS: _nearestCity: %1", _nearestCity];
	
	if (count _nearestCity > 0) then {
		if (((text(_nearestCity select 0)) == "Center") && (count _nearestCity > 1)) then {
			_text = "Bandits Have Been Spotted, near " + (text (_nearestCity select 1));
		} else {
			_text = "Bandits Have Been Spotted, near " + (text (_nearestCity select 0));
		};
	} else {
		_text = "Bandits Have Been Spotted, in the Wilderness";
	};

	if (_mission_warning_debug) then {
		customMission = "<br/>
						<img align='Center' size='4.75' image='%1'/><br/>
						<t size='1' font='Bitstream' align='left' color='#CC0000'>" + _text + "</t><br/>";
		sleep 30;
		customMission = '';
	} else {
		titleText [_text, "PLAIN",6];
	};
};

if (_mission_status == "stop") then {
	_marker_name = _this select 2;
	deleteMarkerLocal _marker;
};