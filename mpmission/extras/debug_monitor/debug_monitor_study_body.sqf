 private ["_body", "_name", "_kills", "_killsH", "_killsB", "_headShots", "_humanity","_temp","_diff","_dateNow","_deathTime","_body","_name","_method","_methodStr"];
 
_body =    _this select 3;
_name =    _body getVariable["bodyName","unknown"];
_method =    _body getVariable["deathType","unknown"];
_deathTime =    _body getVariable["deathTime",-1];
_methodStr = localize format ["str_death_%1",_method];
 
//diag_log ("STUDY: deathtime " +str(_deathTime));
if (_deathTime < 0) then {
    _temp = "unknown";
} else {
    _dateNow = (DateToNumber date);
    _diff = (_dateNow - _deathTime) * 525948;
 
    _temp = "their body has been here for ages, it's freezing";
 
    if ( _diff < 60 ) then {
        _temp = "their body is cold, its been a while since they died";
    };
 
    if ( _diff < 30 ) then {
        _temp = "their body is still slightly warm but their blood has started to coagulate";
    };
 
    if ( _diff < 10 ) then {
        _temp = "their body hasn't been here long, the blood around them is still warm";
    };
};
cutText [format["Their name was %1, %2. There is a journal in their pocket.",_name,_temp], "PLAIN DOWN"];
 
 
_kills = str(_body getVariable ["zombieKills",0]);
_killsH = str(_body getVariable ["humanKills",0]);
_killsB = str(_body getVariable ["banditKills",0]);
_headShots = str(_body getVariable ["headShots",0]);
_humanity = str(_body getVariable ["humanity",0]);
 
customStudyBody =
"<br/><br/><t size='1.25' font='Bitstream' color='#5882FA'>" + _name + " Journal</t><br/><br/>
<t size='1' font='Bitstream' align='left'>Zombies Killed: </t><t size='1.25' font='Bitstream' align='right'>" + _kills + "</t><br/>
<t size='1' font='Bitstream' align='left'>Murders: </t><t size='1.25' font='Bitstream' align='right'>" + _killsH + "</t><br/>
<t size='1' font='Bitstream' align='left'>Bandits Killed: </t><t size='1.25' font='Bitstream' align='right'>" + _killsB + "</t><br/>
<t size='1' font='Bitstream' align='left'>Headshots: </t><t size='1.25' font='Bitstream' align='right'>" + _headShots + "</t><br/>
<t size='1' font='Bitstream' align='left'>Humanity: </t><t size='1.25' font='Bitstream' align='right'>" + _humanity + "</t><br/>";

sleep 15;

customStudyBody = "";