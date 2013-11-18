private ["_id", "_text", "_position", "_marker", "_vehicle_spawn", "_vehicle"];
waitUntil {sleep 1; customMission == ''};

_id = _this select 0;
_position = _this select 1;
_text = _this select 2;
_vehicle_spawn = _this select 3;
_vehicle = _this select 4;

_marker = createMarker[_id, _position];

if !(_vehicle_spawn) then {
	_marker setMarkerColor "ColorRed";
} else {
	_marker setMarkerColor "ColorBlue";
};

_marker setMarkerShape "ELLIPSE";
_marker setMarkerBrush "Grid";
_marker setMarkerSize [300,300];

customMission = "<br/>
				<img align='Center' size='4.75' image='%1'/><br/>
				<t size='1' font='Bitstream' align='left' color='#CC0000'>" + _text + "</t><br/>";
sleep 30;
customMission = '';