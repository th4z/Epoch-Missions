RYD_H_WhatSee = 
	{//[player,[1,1],(AllUnits - [player])] call RYD_H_LetSee
	private ["_hunter","_seeing","_observed","_lightS","_movS","_visible","_nightF","_weatherF","_visR","_speedU","_dmg","_div","_veh","_dst","_posASL",
	"_mpl","_posASL2","_size","_stance","_speed","_place","_valP","_angle","_bckPos","_isSky","_visF","_posH"];
	
	_hunter = _this select 0;
	_seeing = _this select 1;
	_observed = _this select 2;
	
	_lightS = _seeing select 0;
	_movS = _seeing select 1;

	_visible = [];
	_nightF = 0;

	if (sunOrMoon < 0.5) then {_nightF = 3 - (moonIntensity/(1 + overcast))};

	_weatherF = (fog + rain + overcast)/(1 + sunOrMoon);
	_visR = (_weatherF + _nightF)/_lightS;
	
	_speedU = 1 + ((abs (speed _hunter))/10);
	
	_dmg = 1 + (damage _hunter);
	
	_div = _dmg + _visR;
	
	_posH = getPosASL _hunter;
	
		{
		_veh = vehicle _x;
		
		if ((_hunter knowsAbout _veh) < 3) then
			{
			_dst = _hunter distance _veh;
			
			if (_dst < viewDistance) then
				{		
				if not (_veh in _visible) then
					{
					_posASL = getPosASL _veh;
					_mpl = 1/_div;
					_size = sizeOf (typeOf _veh);
					
					if (_x == _veh) then 
						{
						_posASL2 = eyePos _x;
						_size = 1.75;
						_stance = (_posASL2 select 2) - (_posASL select 2);
						_mpl = _mpl * _stance
						};
						
					_speed = 1 + ((abs (speed _veh))/(10 + ((wind call RYD_H_VectorLength)/10)));
					_speed = _speed/(sqrt _speedU);
					
					if (_speed <= 1.25) then {_speed = 0.5} else {_speed = sqrt _speed};
												
					_place = [_posASL,1,5] call RYD_H_TerraCognita;
					_valP = (_place select 0) + (_place select 1);
					
					_mpl = (_mpl * (_size/1.75) * (_speed * _movS))/(1 + _valP);
					
					_angle = [_posH,_posASL,0] call RYD_H_AngTowards;
					
					_bckPos = [_posH,_angle,_dst + 1000] call RYD_H_PosTowards2D;

					_isSky = [_posH,_bckPos,_hunter,_veh] call RYD_H_LOSCheckT;
					
					if (_isSky) then
						{
						_mpl = _mpl * 1.5
						};
						
					_visF = (_mpl * 800) * (0.75 + (random 0.25) + (random 0.25));
				
					if (_dst < _visF) then
						{
						if not ([_veh,_hunter,(getDir _hunter)] call RYD_H_isFlanking) then
							{
							if ([eyepos _hunter,_posASL,_hunter,_veh] call RYD_H_LOSCheck) then
								{
								_visible set [(count _visible),_veh]
								}
							}
						}
					}
				}
			}
		else
			{
			_visible set [(count _visible),_veh]
			}
		}
	foreach _observed;
	
	_visible
	};

RYD_H_MyTrail = 
	{
	_unit = _this select 0;
	_maxAge = _this select 1;
	
	_alive = true;
	_trail = [[getPosATL _unit,time]];
	RYD_Hunter_FSM_handle setFSMVariable ["RYD_H_Trail" + (str _unit),_trail];
	RYD_Hunter_FSM_handle setFSMVariable ["RYD_H_Side" + (str _unit),side _unit];
	
	_ct = 0;
	
	while {(true)} do
		{
		sleep 10;
		_ct = _ct + 10;
		if (isNull _unit) exitWith {}; 

		if not (alive _unit) then {_alive = false};
		
		_trail = RYD_Hunter_FSM_handle getFSMVariable ("RYD_H_Trail" + (str _unit));
		if (isNil "_trail") then {_trail = []};
		
		if ((_ct > _maxAge) or ((count _trail) > 1000)) then
			{
			_trail set [0,"Delete"];
			_trail = _trail - ["Delete"];
			_ct = 0
			};
			
		if (not (_alive) and ((count _trail) == 0)) exitWith {};
		
		//_lastFoot = _trail select ((count _trail) - 1);
		_newFoot = getPosATL _unit;		
		
		if (surfaceIsWater [(_newFoot select 0),(_newFoot select 1)]) then
			{
			_newFoot = "Delete"
			}
		/*else
			{
			_mark = [_newFoot,(random 1000),"markFoot","ColorGreen","ICON","mil_dot","","",[0.35,0.35]] call RYD_H_Mark;
			}*/;
		
		_trail set [(count _trail),[_newFoot,time]];

			{
			if ((rain > (random 5)) or ((random 1) > 0.98)) then {_trail set [_foreachIndex,"Delete"]}
			}
		foreach _trail;
		
		RYD_Hunter_FSM_handle setFSMVariable ["RYD_H_Trail" + (str _unit),_trail]
		}
	};
	
RYD_H_NewFoot = 
	{
	private ["_hunter","_smell","_hunted","_trails","_cTrails","_int","_wind","_hPos","_fromDir","_diff","_intensity","_ix","_maxVal","_newFoot","_foot","_oldFoot","_oldTime","_preys","_trail"];
	
	_hunter = _this select 0;
	_smell = _this select 1;
	_hunted = _this select 2;
	
	_oldFoot = RYD_Hunter_FSM_handle getFSMVariable ("RYD_H_CurrentFoot" + (str _hunter));
	if (isNil "_oldFoot") then {_oldFoot = [(getPosATL _hunter),-1]};
	_oldTime = _oldFoot select 1;
	_oldFoot = _oldFoot select 0;
	
	_trails = [];
	_preys = [];
	
		{
		if not ((vehicle _x) in _preys) then
			{
			_trail = RYD_Hunter_FSM_handle getFSMVariable ("RYD_H_Trail" + (str _x));
			if (isNil "_trail") then {_trail = []};
			_preys set [(count _preys),(vehicle _x)];
			_trails set [(count _trails),_trail]
			}
		}
	foreach _hunted;
	
	_cTrails = [];
	_int = [];
	_windD = wind call RYD_H_VectorDirXY;
	_windS = wind call RYD_H_VectorLength;
	_hPos = getPosATL _hunter;

		{

			{
			if ((typeName _x) == "ARRAY") then
				{
				_actTime = _x select 1;

				if (_actTime > _oldTime) then
					{
					_foot = _x select 0;

					if ((_foot distance _oldFoot) > 5) then
						{
						_fromDir = [_foot,_hPos,0] call RYD_H_AngTowards;
						_diff = 1 + (abs (_fromDir - _windD));
						_sFactor = _windS * (cos _diff);
						_intensity = (20 + ((280 + (10 * _windS))/(sqrt _diff))) * (0.75 + (random 0.25) + (random 0.25));
						if (_intensity < 1) then {_intensity = 1}; 
						
						if ((_foot distance _hunter) < (_intensity * _smell)) then
							{
							_cTrails set [(count _cTrails),_x];
							_int set [(count _int),_intensity]
							}
						}
					}
				}
			}
		foreach _x
		}
	foreach _trails;
	
	_newFoot = RYD_Hunter_FSM_handle getFSMVariable ("RYD_H_LastKnownPos" + (str _hunter));
	if (isNil "_newFoot") then {_newFoot = [(getPosATL _hunter),-1]};
	RYD_Hunter_FSM_handle setFSMVariable ["RYD_H_LastKnownPos" + (str _hunter),[(getPosATL _hunter),-1]];
	
	if ((count _cTrails) > 0) then
		{
		_ix = 0;
		_maxVal = 0;
		
			{
			if (_x > _maxVal) then
				{
				_maxVal = _x;
				_ix = _foreachIndex
				}
			}
		foreach _int;

		_newFoot = _cTrails select _ix
		};
	
	_hunter setVariable ["RYD_H_CurrentFoot",_newFoot];
	
	_newFoot
	};
		
HNT_Strike_Anims = 
	[
	"amelpercmstpsnonwnondnon_amateruder1",
	"amelpercmstpsnonwnondnon_amateruder2",
	"amelpercmstpsnonwnondnon_amateruder3"
	];
	
RYD_H_Strike = 
	{
	private ["_hunter","_hunted","_angle","_anim","_dmg","_mpl"];
//hint "strike";	
	_hunter = _this select 0;
	_hunted = _this select 1;
	_mpl = _this select 2;
	
	_angle = [(getPosATL _hunter),(getPosATL _hunted),5] call RYD_H_AngTowards;
	
	_anim = HNT_Strike_Anims select (floor (random (count HNT_Strike_Anims)));
	
	_hunter setDir _angle;
	_hunter switchMove _anim;
	
	_hunted reveal [_hunter,3];
	
	sleep (0.35 + (random 0.15));
	
	if not ((isNull _hunter) or (isNull _hunted)) then
		{
		if (alive _hunter) then
			{
			if ((_hunter distance _hunted) < 3) then
				{
				_dmg = damage _hunted;
				_hunted setDamage ((_dmg + (random 1)) * _mpl)
				} 
			}
		}
	};
	
RYD_H_Charge = 
	{
	private ["_hunter","_hunted","_alive","_ct","_dst","_pos","_mpl"];
	
	_hunter = _this select 0;
	_hunted = _this select 1;
	_mpl = _this select 2;
	
	_hunter setUnitPos "UP";
	_hunter forceSpeed -1;
	_hunter stop false;
	
	_pos = [(getPosATL _hunted),((getDir _hunted) + 180),1] call RYD_H_PosTowards2D;
	
	_hunter doMove _pos;//mark1 setMarkerPos (getPosATL _hunted);mark1 setMarkerColor "ColorRed";mark1 setMarkerText "Charge";
	_hunter setBehaviour "COMBAT";
	
	_alive = true;
	_ct = 0;
	_dst = _hunter distance _hunted;
	
	waitUntil
		{
		sleep 0.2;
		_ct = _ct + 0.2;
		
		if ((isNull _hunter) or (isNull _hunted)) then {_alive = false};
		if (not (alive _hunter) or not (alive _hunted)) then {_alive = false};
		
		if (_alive) then
			{
			if ((abs (speed _hunter)) < 0.1) then {_ct = _ct + 1.8};
			if ((floor _ct) == _ct) then
				{
				_pos = [(getPosATL _hunted),((getDir _hunted) + 0),1] call RYD_H_PosTowards2D;
				_hunter doMove _pos
				};
				
			_dst = _hunter distance _hunted;//mark1 setMarkerPos (getPosATL _hunted);
			};
		
		(not (_alive) or (_dst < 2) or (_ct > 10))
		};
	
	while {((_hunter distance _hunted) < 3)} do
		{
		if ((isNull _hunter) or (isNull _hunted)) exitWith {};
		if (not (alive _hunter) or not (alive _hunted)) exitWith {};
		[_hunter,_hunted,_mpl] call RYD_H_Strike;
		sleep 0.1
		};
		
	if not (isNull _hunter) then
		{	
		RYD_Hunter_FSM_handle setFSMVariable ["RYD_H_isCharging" + (str _hunter),false];
		_hunter setUnitPos "AUTO";
		}
	};
	
RYD_H_RunHide = 
	{
	private ["_hunter","_hunted","_pos","_ct","_isFlanking","_isLOS","_alive","_dst","_cnt","_posATL"];
	
	_hunter = _this select 0;
	_hunted = _this select 1;
	
	_dst2 = _hunter distance _hunted;
	
	_hunter setUnitPos "UP";
	_hunter stop false;
	_hunter doWatch objNull;
	_hunter forceSpeed -1;
		
	_posATL = getPosATL _hunter;
	_posATL2 = getPosATL _hunted;
	_posASL2 = eyePos _hunted;
	
	_pos = [];
	_ct = 0;
	
	while {(_ct < 200)} do
		{
		_ct = _ct + 1;
		_pos = [_posATL,50,800] call RYD_H_RandomAroundMM;
		
		_cnt = 0;
		
		while {((surfaceIsWater [_pos select 0,_pos select 1]) and (_cnt < 100))} do
			{
			_cnt = _cnt + 1;
			_pos = [_posATL,50,800] call RYD_H_RandomAroundMM
			};
			
		_toLineDst = [_posATL,_pos,_posATL2] call RYD_H_PointToSecDst;

		_isLOS = true;
	
		if (_toLineDst <= (_posATL distance _pos)) then
			{
			_pos = ATLtoASL _pos;
			_isLOS = [_pos,_posASL2,_hunter,_hunted] call RYD_H_LOSCheck;
			};
	
		if not (_isLOS) exitWith {};
		_pos = []
		};
		
	//diag_log format ["hidePos: %1",_pos];
		
	if ((count _pos) < 3) then
		{
		RYD_Hunter_FSM_handle setFSMVariable ["RYD_H_isRunning" + (str _hunter),false];
		[_hunter,_hunted,_mpl] spawn RYD_H_Charge
		}
	else
		{
		_hunter doMove _pos;//mark1 setMarkerPos _pos;mark1 setMarkerColor "ColorBrown";mark1 setMarkerText "Hide";
		_hunter setBehaviour "COMBAT";
		
		_alive = true;
		_ct = 0;
		_dst = _hunter distance _pos;
		
		waitUntil
			{
			sleep 2;
			_ct = _ct + 2;
			
			if (isNull _hunter) then {_alive = false};
			if not (alive _hunter) then {_alive = false};
			
			if (_alive) then
				{
				if ((abs (speed _hunter)) < 0.1) then {_ct = _ct + 18};
				_dst = _hunter distance _pos;
				_isLOS = [eyepos _hunter,(getPosASL _hunted),_hunter,_hunted] call RYD_H_LOSCheck
				};
			
			(not (_alive) or (_dst < 3) or (_ct > 100) or not (_isLOS))
			};
		
		_step = 50;
		_flDst = (_hunter distance _hunted);
		_flPos = [(getPosATL _hunted),((getDir _hunted) + 180),_flDst] call RYD_H_PosTowards2D;

		_isLOS = [_flPos,(getPosASL _hunted),_hunter,_hunted] call RYD_H_LOSCheck;
		
		while {(_isLOS)} do
			{
			_flDst = _flDst + 50;
			_flPos = [(getPosATL _hunted),((getDir _hunted) + 180),_flDst] call RYD_H_PosTowards2D;

			_isLOS = [_flPos,(getPosASL _hunted),_hunter,_hunted] call RYD_H_LOSCheck
			};
			
		_route = [_hunter,_hunted,_flPos,2] call RYD_H_FlankingRoute;
		
			{
			_hunter doMove _x;
			
			_dst = _hunter distance _x;
			_dst2 = _hunter distance _hunted;
			_alive = true;
			_ct = 0;
			
			waitUntil
				{
				sleep 2;
				
				if (isNull _hunter) then {_alive = false};
				if not (alive _hunter) then {_alive = false};
			
				if (_alive) then
					{
					if ((abs (speed _hunter)) < 0.1) then 
						{
						_ct = _ct + 2;
						
						if ((floor (_ct/10)) == (_ct/10)) then
							{
							_hunter doMove _x
							}
						};
						
					_dst = _hunter distance _x;
					_dst2 = _hunter distance _hunted
					};
				
				(not (_alive) or (_dst < 3) or (_dst2 < 25) or (_ct > 100) or (unitReady _hunter))
				}
			}
		foreach _route;
				 
		RYD_Hunter_FSM_handle setFSMVariable ["RYD_H_isRunning" + (str _hunter),false];
		_hunter setUnitPos "AUTO";
//diag_log "----------------------------RUN END";		
		if (_dst2 < 25) then
			{
			[_hunter,_hunted,_mpl] spawn RYD_H_Charge
			}
		};
	};
	
RYD_H_Ambuscade = 
	{
	private ["_hunter","_hunted"];
	
	_hunter = _this select 0;
	_hunted = _this select 1;
		
	_hunter doMove (getPosATL _hunter);
	_hunter setUnitPos "DOWN";
	_hunter forceSpeed 0;
	_hunter setBehaviour "COMBAT";
	doStop _hunter;//mark1 setMarkerColor "ColorBlue";mark1 setMarkerText "Ambush";
	_hunter lookAt _hunted;
	_hunter doWatch _hunted;
	_hunter stop true
	};
	
RYD_H_Sneak = 
	{
	private ["_hunter","_hunted"];
	
	_hunter = _this select 0;
	_hunted = _this select 1;
			
	_hunter stop false;
	
	_hunter doMove (getPosATL _hunted);//mark1 setMarkerPos (getPosATL _hunted);mark1 setMarkerColor "ColorYellow";mark1 setMarkerText "Sneak";
		
	_hunter setUnitPos "DOWN";
	_hunter forceSpeed 2;
	_hunter setBehaviour "COMBAT"
	};
	
