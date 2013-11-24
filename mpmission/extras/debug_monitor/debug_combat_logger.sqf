private ["_player_name"];
waitUntil {sleep 1; customCombatLogger == ''};

_player_name = 	_this select 0;
_text = (localize "STR_custom_combatlogger");

customCombatLogger = "<br/>
				<img align='Center' size='4.75' image='%2'/><br/>
				<t size='1' font='Bitstream' align='left' color='#CC0000'>" + _player_name + "</t><br/>
				<t size='1' font='Bitstream' align='left' color='#CC0000'>" + _text + "</t><br/>";
sleep 15;
customCombatLogger = "";