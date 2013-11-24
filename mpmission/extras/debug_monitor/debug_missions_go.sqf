private ["_id", "_text", "_position", "_marker", "_vehicle_spawn", "_vehicle"];
waitUntil {sleep 1; customMission == ''};

_text = _this select 0;
_vehicle_spawn = _this select 1;
_vehicle = _this select 2;


customMission = "<br/>
				<img align='Center' size='4.75' image='%1'/><br/>
				<t size='1' font='Bitstream' align='left' color='#CC0000'>" + _text + "</t><br/>";
sleep 30;
customMission = '';