private ["_id", "_text", "_position", "_marker"];
waitUntil {sleep 1; customMission == ''};

diag_log format ["DEBUG: Mission Code: Debug Monitor: %1", _this];
_id = _this select 0;
_text = 	_this select 1;
_position = _this select 2;

_marker = createMarker[_id, _position];
_marker setMarkerColor "ColorRed";
_marker setMarkerShape "ELLIPSE";
_marker setMarkerBrush "Grid";
_marker setMarkerSize [300,300];

customMission = "<br/>
				<img align='Center' size='4.75' image='%11'/><br/>
				<t size='1' font='Bitstream' align='left' color='#CC0000'>%12 </t><br/>
				<t size='1' font='Bitstream' align='left' color='#CC0000'>" + _text + "</t><br/>";
sleep 30;
customMission = '';