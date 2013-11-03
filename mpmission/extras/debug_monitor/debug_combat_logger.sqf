private ["_player_name"];
waitUntil {sleep 1; customCombatLogger == ''};

_player_name = 	_this select 0;

customCombatLogger = "<br/>
				<img align='Center' size='4.75' image='%10'/><br/>
				<t size='1' font='Bitstream' align='left' color='#CC0000'>%12 </t><br/>
				<t size='1' font='Bitstream' align='left' color='#CC0000'>" + (localize "STR_custom_combatlogger") + "</t>";
sleep 10;
customCombatLogger = '';