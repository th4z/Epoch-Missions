waitUntil {sleep 1; customCombatLogger == ''};


customCombatLogger = "<br/><img align='Center' size='4.75' image='%2'/><br/><t size='1' font='Bitstream' align='left' color='#CC0000'>" + str(_this) + " " + str(localize "STR_custom_combatlogger") + "</t><br/>";
sleep 15;
customCombatLogger = "";