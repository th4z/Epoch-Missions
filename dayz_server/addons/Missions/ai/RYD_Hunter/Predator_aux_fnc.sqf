RYD_H_Mark = 
	{//_i = [[_posX,_posY],_unitG,"markCapture","ColorRed","ICON","mil_dot","Cap A"," - SECURE AREA"] call RYD_H_Mark
	private ["_pos","_ref","_pfx","_cl","_shp","_tp","_sz","_dir","_txt","_i"];
	
	_pos = _this select 0;

	if (isNil "_pos") exitWith {};

	_ref = _this select 1;
	_pfx = _this select 2;

	_cl = _this select 3;
	_shp = _this select 4;
	_tp = _this select 5;
	_txt = _this select 6;

	_sz = [1,1];
	if ((count _this) > 8) then {_sz = _this select 8};

	_dir = 0;
	if ((count _this) > 9) then {_dir = _this select 9};

	if ((typeName _pos) == "OBJECT") then {_pos = position _pos};

	if not ((typename _pos) == "ARRAY") exitWith {};
	if ((_pos select 0) == 0) exitWith {};
	if ((count _pos) < 2) exitWith {};

	_i = _pfx + (str _ref);
	_i = createMarker [_i,_pos];
	_i setMarkerColor _cl;
	_i setMarkerShape _shp;
	if (_shp =="ICON") then {_i setMarkerType _tp} else {_i setMarkerBrush _tp};
	_i setMarkerSize _sz;
	_i setMarkerDir _dir;
	_i setMarkerText _txt;

	_i
	};

RYD_H_VectorDirXY =
	{
	private ["_dir"];
	
	_dir = (_this select 0) atan2 (_this select 1);
	if (_dir < 0) then {_dir = _dir + 360};
	
	_dir
	};
	
RYD_H_VectorLength = 
	{
	private ["_length"];
	
	//_length = sqrt (((_this select 0)^2) + ((_this select 1)^2) + ((_this select 2)^2));
	_length = _this distance [0,0,0];
	
	_length
	};
	
RYD_H_AngTowards = 
	{
	private ["_source0", "_target0", "_rnd0","_dX0","_dY0","_angleAzimuth0"];

	_source0 = _this select 0;
	_target0 = _this select 1;
	_rnd0 = _this select 2;

	_dX0 = (_target0 select 0) - (_source0 select 0);
	_dY0 = (_target0 select 1) - (_source0 select 1);

	_angleAzimuth0 = (_dX0 atan2 _dY0) + (random (2 * _rnd0)) - _rnd0;
	
	if (_angleAzimuth0 < 0) then {_angleAzimuth0 = _angleAzimuth0 + 360};

	_angleAzimuth0
	};
	
RYD_H_PosTowards2D = 
	{
	private ["_source","_distT","_angle","_dXb","_dYb","_px","_py"];

	_source = _this select 0;
	_angle = _this select 1;
	_distT = _this select 2;

	_dXb = _distT * (sin _angle);
	_dYb = _distT * (cos _angle);

	_px = (_source select 0) + _dXb;
	_py = (_source select 1) + _dYb;

	_pz = getTerrainHeightASL [_px,_py];

	[_px,_py,_pz]
	};
	
RYD_H_TerraCognita = 
	{
	private ["_position","_posX","_posY","_radius","_precision","_sourcesCount","_urban","_forest","_hills","_flat","_sea","_valS","_value","_val0","_samples","_sGr","_hprev","_hcurr","_samplePos","_i","_rds"];	

	_position = _this select 0;
	_samples = _this select 1;
	_rds = 100;
	if ((count _this) > 2) then {_rds = _this select 2};

	if not ((typeName _position) == "ARRAY") then {_position = getPosATL _position};

	_posX = _position select 0;
	_posY = _position select 1;

	_radius = 5;
	_precision = 1;
	_sourcesCount = 1;

	_urban = 0;
	_forest = 0;
	_hills = 0;
	_flat = 0;
	_sea = 0;

	_sGr = 0;
	_hprev = getTerrainHeightASL [_posX,_posY];

	for "_i" from 1 to 10 do
		{
		_samplePos = [_posX + ((random (_rds * 2)) - _rds),_posY + ((random (_rds * 2)) - _rds)];
		_hcurr = getTerrainHeightASL _samplePos;
		_sGr = _sGr + abs (_hcurr - _hprev)
		};

	_sGr = _sGr/10;

		{
		_valS = 0;

		for "_i" from 1 to _samples do
			{
			_position = [_posX + (random (_rds/5)) - (_rds/10),_posY + (random (_rds/5)) - (_rds/10)];


			_value = selectBestPlaces [_position,_radius,_x,_precision,_sourcesCount];

			_val0 = _value select 0;
			_val0 = _val0 select 1;

			_valS = _valS + _val0;
			};

		_valS = _valS/_samples;

		switch (_x) do
			{
			case ("Houses") : {_urban = _urban + _valS};
			case ("Trees") : {_forest = _forest + (_valS/3)};
			case ("Forest") : {_forest = _forest + _valS};
			case ("Hills") : {_hills = _hills + _valS};
			case ("Meadow") : {_flat = _flat + _valS};
			case ("Sea") : {_sea = _sea + _valS};
			};
		}
	foreach ["Houses","Trees","Forest","Hills","Meadow","Sea"];

	[_urban,_forest,_hills,_flat,_sea,_sGr]
	};

RYD_H_LOSCheck = 
	{
	private ["_pos1","_pos2","_tint","_lint","_isLOS","_cam","_target","_pX1","_pY1","_pX2","_pY2","_pos1ATL","_pos2ATL"];

	_pos1 = _this select 0;
	_pos2 = _this select 1;

	_pX1 = _pos1 select 0;
	_pY1 = _pos1 select 1;

	_pX2 = _pos2 select 0;
	_pY2 = _pos2 select 1;

	_pos1ATL = [_pX1,_pY1,1.5];
	_pos2ATL = [_pX2,_pY2,1.5];

	_cam = objNull;

	if ((count _this) > 2) then {_cam = _this select 2};

	_target = objNull;

	if ((count _this) > 3) then {_target = _this select 3};

	_tint = terrainintersect [_pos1ATL, _pos2ATL]; 
	_lint = lineintersects [_pos1, _pos2,_cam,_target]; 

	_isLOS = true;

	if ((_tint) or (_lint)) then {_isLOS = false};

	_isLOS
	};

RYD_H_LOSCheckT = 
	{
	private ["_pos1","_pos2","_isLOS","_tint"];

	_pos1 = _this select 0;
	_pos2 = _this select 1;

	_tint = terrainintersectASL [_pos1,_pos2]; 

	_isLOS = true;
	if (_tint) then {_isLOS = false};

	_isLOS
	};
	
RYD_H_isFlanking = 
	{
	private ["_point","_Rpoint","_angle","_diffA","_axis","_isFlanking"];	

	_point = _this select 0;
	_rPoint = _this select 1;
	_axis = _this select 2;
	
	if ((typeName _point) == "OBJECT") then
		{
		_point = getPosATL _point
		};
		
	if ((typeName _rPoint) == "OBJECT") then
		{
		_rPoint = getPosATL _rPoint
		};

	_angle = [_rPoint,_point,0] call RYD_H_AngTowards;

	_isFlanking = false;

	if (_angle < 0) then {_angle = _angle + 360};
	if (_axis < 0) then {_axis = _axis + 360};  

	_diffA = _angle - _axis;

	if (_diffA < 0) then {_diffA = _diffA + 360};

	if ((_diffA > 80) and (_diffA < 280)) then 
		{
		_isFlanking = true
		};

	_isFlanking
	};
	
RYD_H_FindClosest = 
	{
	private ["_ref","_objects","_closest","_dstMin","_dstAct"];

	_ref = _this select 0;
	_objects = _this select 1;

	_closest = objNull;

	if ((count _objects) > 0) then 
		{
		_closest = _objects select 0;

		_dstMin = _ref distance (position _closest);

			{
			_dstAct = _ref distance (position _x);

			if (_dstAct < _dstMin) then
				{
				_closest = _x;
				_dstMin = _dstAct
				}
			}
		foreach _objects
		};

	_closest
	};
	
RYD_H_FindClosestB = 
	{
	private ["_ref","_objects","_closest","_dstMin","_dstAct"];

	_ref = _this select 0;
	_objects = _this select 1;

	_closest = [];

	if ((count _objects) > 0) then 
		{
		_closest = _objects select 0;

		_dstMin = _ref distance _closest;

			{
			_dstAct = _ref distance _x;

			if (_dstAct < _dstMin) then
				{
				_closest = _x;
				_dstMin = _dstAct
				}
			}
		foreach _objects
		};

	_closest
	};
	
RYD_H_FindClosestWithIndex = 
	{
	private ["_ref","_objects","_closest","_dstMin","_dstAct","_index","_clIndex"];

	_ref = _this select 0;
	_objects = _this select 1;

	_closest = objNull;

	if ((count _objects) > 0) then 
		{
		_closest = _objects select 0;
		_index = 0;
		_clIndex = 0;
		_dstMin = _ref distance _closest;

			{
			_dstAct = _ref distance _x;

			if (_dstAct < _dstMin) then
				{
				_closest = _x;
				_dstMin = _dstAct;
				_clIndex = _index
				};

			_index = _index + 1
			}
		foreach _objects
		};

	[_closest,_clIndex]
	};
	
RYD_H_DistOrd = 
	{
	private ["_array","_point","_final","_closest","_ix"];

	_array = _this select 0;
	_point = _this select 1;

	_final = [];

	while {((count _array) > 0)} do
		{
		_closest = [_point,_array] call RYD_H_FindClosestWithIndex;
		_ix = _closest select 1;
		_closest = _closest select 0;
		
		_final set [(count _final),_closest];

		_array set [_ix,"Delete"];
		_array = _array - ["Delete"]
		};

	_final
	};
	
RYD_H_RandomAroundMM = 
	{//based on Muzzleflash' function
	private ["_pos","_xPos","_yPos","_a","_b","_dir","_angle","_mag","_nX","_nY","_temp"];

	_pos = _this select 0;
	_a = _this select 1;
	_b = _this select 2;
	
	_b = _b - _a;

	_xPos = _pos select 0;
	_yPos = _pos select 1;

	_dir = random 360;

	_mag = _a + (sqrt ((random _b) * _b));
	_nX = _mag * (sin _dir);
	_nY = _mag * (cos _dir);

	_pos = [_xPos + _nX, _yPos + _nY,0];  

	_pos	
	};
	
RYD_H_PointToSecDst = 
	{
	private ["_p1","_p2","_pc","_d","_d0","_d1","_d2","_x1","_y1","_x2","_y2","_xc","_yc","_a","_b"];

	_p1 = _this select 0;//ATL
	_p2 = _this select 1;//ATL
	_pc = _this select 2;//ATL

	_d0 = _p1 distance _p2;
	_d1 = _pc distance _p1;
	_d2 = _pc distance _p2;

	_d = _d1;

	switch (true) do
		{
		case (((_d0 * _d0) + (_d1 * _d1)) <= (_d2 * _d2)) : {_d = _d1};
		case (((_d0 * _d0) + (_d2 * _d2)) <= (_d1 * _d1)) : {_d = _d2};
		default
			{
			_x1 = _p1 select 0;
			_y1 = _p1 select 1;

			_x2 = _p2 select 0;
			_y2 = _p2 select 1;

			_xc = _pc select 0;
			_yc = _pc select 1;

			_a = (_y2 - _y1)/(_x2 - _x1);
			_b = _y1 - _x1 * _a;

			_d = abs (((_a/_b) * _xc) + ((-1/_b) * _yc) + 1)/(sqrt (((_a/_b) * (_a/_b)) + (1/(_b * _b))));
			}
		};

	_d
	};
	
RYD_H_WhereIs = 
	{
	private ["_point","_Rpoint","_angle","_diffA","_axis","_isLeft","_isFlanking","_isBehind"];	

	_point = _this select 0;
	_rPoint = _this select 1;
	_axis = _this select 2;

	_angle = [_rPoint,_point,0] call RYD_H_AngTowards;

	_isLeft = false;
	_isFlanking = false;
	_isBehind = false;

	if (_angle < 0) then {_angle = _angle + 360};
	if (_axis < 0) then {_axis = _axis + 360};

	_diffA = _angle - _axis;

	if (_diffA < 0) then {_diffA = _diffA + 360};

	if (_diffA > 180) then 
		{
		_isLeft = true
		};

	if ((_diffA > 60) and (_diffA < 300)) then 
		{
		_isFlanking = true
		};

	if ((_diffA > 120) and (_diffA < 240)) then 
		{
		_isBehind = true
		};

	[_isLeft,_isFlanking,_isBehind]
	};

RYD_H_Sectorize = 
	{
	private ["_ctr","_lng","_ang","_nbr","_EdgeL","_rd","_main","_step","_X1","_Y1","_posX","_posY","_centers","_first",
	"_sectors","_centers2","_Xa","_Ya","_dXa","_dYa","_dst","_ang2","_Xb","_Yb","_dXb","_dYb","_center","_crX","_crY","_crPoint","_sec","_hunter"];

	_ctr = _this select 0;
	_lng = _this select 1;
	_ang = _this select 2;
	_nbr = _this select 3;
	_hunter = _this select 4;

	_EdgeL = _lng/_nbr;
	
	_rd = _lng/2;

	_main = createLocation ["Name", _ctr, _rd, _rd];
	RYD_Hunter_FSM_handle setFSMVariable ["RYD_H_Sectors" + (str _hunter),[_main]];
	_main setRectangular true;

	_step = _EdgeL;

	_X1 = _ctr select 0;
	_Y1 = _ctr select 1;

	_posX = (_X1 - _rd) + _step/2;
	_posY = (_Y1 - _rd) + _step/2;

	_centers = [[_posX,_posY]];
	_first = false;

	while {(true)} do
		{
		while {(true)} do
			{
			if not (_first) then {_first = true;_posX = _posX + _step};
			if not ([_posX,_PosY] in _main) exitwith {_posX = ((_ctr select 0) - _rd) + _step/2;_first = true};

			_centers set [(count _centers),[_posX,_posY]];
			_first = false

			};
		_posY = _posY + _step;
		if not ([_posX,_PosY] in _main) exitwith {}
		};

	if not (_ang in [0,90,180,270]) then
		{
		_main setDirection _ang;
		_centers2 = _centers;
		_centers = [];

			{
			_Xa = _x select 0;
			_Ya = _x select 1;
			_dXa = (_X1 - _Xa);
			_dYa = (_Y1 - _Ya);
			_dst = [_X1,_Y1,0] distance [_Xa,_Ya,0];

			_ang2 = _ang + (_dXa atan2 _dYa);

			_dXb = _dst * (sin _ang2);
			_dYb = _dst * (cos _ang2);

			_Xb = _X1 + _dXb;
			_Yb = _Y1 + _dYb;
			_center = [_Xb,_Yb];
			_centers set [(count _centers),_center]
			}
		foreach _centers2
		};
	
	_sectors = [];

		{
		_crX = _x select 0;
		_crY = _x select 1;
					
		if not (surfaceIsWater [_crX,_crY]) then
			{
			_crPoint = [_crX,_crY,0];
			_sec = createLocation ["Name", _crPoint, _EdgeL/2, _EdgeL/2];
			_sectors set [(count _sectors),_sec];
			RYD_Hunter_FSM_handle setFSMVariable ["RYD_H_Sectors" + (str _hunter),_sectors + [_main]];
			_sec setDirection _ang;
			_sec setRectangular true
			}
		}
	foreach _centers;

	_sectors	
	};
		
RYD_H_Marker = 
	{
	private ["_name","_pos","_cl","_shape","_size","_dir","_alpha","_type","_brush","_text","_i"];	

	_name = _this select 0;
	_pos = _this select 1;
	_cl = _this select 2;
	_shape = _this select 3;

	_shape = toUpper (_shape);

	_size = _this select 4;
	_dir = _this select 5;
	_alpha = _this select 6;

	if not (_shape == "ICON") then {_brush = _this select 7} else {_type = _this select 7};
	_text = _this select 8;

	if not ((typename _pos) == "ARRAY") exitWith {};
	if ((_pos select 0) == 0) exitWith {};
	if ((count _pos) < 2) exitWith {};
//diag_log format ["BB mark: %1 pos: %2 col: %3 size: %4 dir: %5 text: %6",_name,_pos,_cl,_size,_dir,_text];
	if (isNil "_pos") exitWith {};

	_i = _name;
	_i = createMarker [_i,_pos];
	_i setMarkerColor _cl;
	_i setMarkerShape _shape;
	_i setMarkerSize _size;
	_i setMarkerDir _dir;
	if not (_shape == "ICON") then {_i setMarkerBrush _brush} else {_i setMarkerType _type};
	_i setMarkerAlpha _alpha;
	_i setmarkerText _text;

	_i
	};
	
RYD_H_SecEnvelope = 
	{
	private ["_sectors","_minX","_maxX","_minY","_maxY","_pos","_pX","_pY"];
	
	_sectors = _this select 0;
	
	_minX = (position (_sectors select 0)) select 0;
	_maxX = _minX;
	
	_minY = (position (_sectors select 0)) select 1;
	_maxY = _minY;
	
		{
		_pos = position _x;
		_pX = _pos select 0;
		_pY = _pos select 1;
		
		if (_pX < _minX) then
			{
			_minX = _pX
			}
		else
			{
			if (_pX > _maxX) then
				{
				_maxX = _pX
				}
			};
			
		if (_pY < _minY) then
			{
			_minY = _pY
			}
		else
			{
			if (_pY > _maxY) then
				{
				_maxY = _pY
				}
			};
		
		}
	foreach _sectors;
	
	[[_minX,_maxX],[_minY,_maxY]]
	};
	
RYD_H_FindNearSec = 
	{
	private ["_loc","_rds","_near"];
	
	_loc = _this select 0;
	_rds = _this select 1;
	
	if not ((typeName _loc) in ["ARRAY"]) then
		{
		_loc = position _loc
		};
	
	_loc = [(_loc select 0),(_loc select 1)];
	
	_near = [];
	
	_near = nearestLocations [_loc, ["Name"], _rds];

		{
		if (isNil {RYD_Hunter_FSM_handle getFSMVariable ("Cost_Loc" + (str _x))}) then
			{
			_near set [_foreachIndex,"Del"]
			}
		}
	foreach _near;
	
	_near = _near - ["Del"];
	
	_near
	};
	
RYD_H_MainCluster = 
	{
	private ["_sec","_rds","_pos","_clusters","_cluster","_sc","_nearS","_main","_within"];
	
	_sec = _this select 0;
	_rds = _this select 1;
	_pos = _this select 2;
	
	_clusters = [];
	
	while {((count _sec) > 0)} do
		{
		_cluster = [(_sec select 0)];
		
		while {(true)} do
			{
			_cnt1 = count _cluster;
			
				{
				_sc = _x;
				_exit = false;
				
				if not (_sc in _cluster) then
					{
					_nearS = ([_sc,_rds] call RYD_H_FindNearSec) - [_sc];
					
					if ((count _nearS) > 0) then
						{
						if (((count _cluster) == 1) or (({_x in _cluster} count _nearS) > 0)) then
							{
							_cluster set [(count _cluster),_sc];
							_exit = true
							}
						}
					};
					
				if (_exit) exitWith {}
				}
			foreach _sec;
			
			_sec = _sec - _cluster;
			_cnt2 = count _cluster;
			
			if (_cnt1 == _cnt2) exitWith {}
			};
		
		_clusters set [(count _clusters),_cluster]
		};
		
	_main = [];
		
		{
		_within = false;
		
			{
			if ((_pos distance (position _x)) < _rds) exitWith
				{
				_within = true
				}
			}
		foreach _x;
		
		if (_within) exitWith
			{
			_main = _x
			}
		}
	foreach _clusters;
	
	_main
	};
		
RYD_H_CheapestRoute = 
	{
	private ["_pos1","_pos2","_sec","_hidden","_route","_first","_final","_step","_ix1","_flanked","_borderS","_pnt1","_ix2","_violate","_pnt2","_dst","_angle","_part","_checkPoint","_routeA",
	"_diff","_route0","_cnt1","_ref","_dstRef","_cnt2","_last","_isLast","_fl"];
	
	_pos1 = _this select 0;
	_pos2 = _this select 1;
	_sec = _this select 2;
	_hidden = _this select 3;
	_flanked = _this select 4;
	_borderS = _this select 5;
	_isLast = _this select 6;
	
	_first = [_pos1,_hidden] call RYD_H_FindClosest;
	
	_fl = _hidden;
	if (_isLast) then
		{
		_fl = _sec
		};
	
	_final = [_pos2,_fl] call RYD_H_FindClosest;
		
	_route = [_first] + _borderS + [_final];
			
		/*{
		_mark = _x getVariable "Over_Mark";	
		_mark setMarkerAlpha 0.8;
		}
	foreach _route;*/
			
	_step = ((size (_sec select 0)) select 0) * 2;
	
	_ix1 = -1;
	
	while {(_ix1 < (count _route))} do
		{
		_ix1 = _ix1 + 1;

		_pnt1 = position (_route select _ix1);
		_ix2 = 0;
		_violate = false;

		for [{_x = ((count _route) - 1)},{_x > _ix1},{_x = _x - 1}] do
			{
			_pnt2 = position (_route select _x);
			_dst = _pnt1 distance _pnt2;
			_ix2 = _x;

			_angle = [_pnt1,_pnt2,0] call RYD_H_AngTowards;
			
			_violate = false;
			_part = 0;
			
			while {(_part < _dst)} do
				{
				_part = _part + _step;
				_checkPoint = [_pnt1,_angle,_part] call RYD_H_PosTowards2D;
				
					{
					if (_checkPoint in _x) exitWith
						{
						_violate = true
						}
					}
				foreach (_sec - _hidden);
				
				if (_violate) exitWith {}
				};
				
			if not (_violate) exitWith
				{
				_routeA = +_route;
				
				_route = [];
				
					{
					if (not (_foreachIndex > _ix1) or not (_foreachIndex < _ix2)) then
						{
						_route set [(count _route),_x]
						}
					}
				foreach _routeA
				}
			
			};
		
		if ((count _route) < 3) exitWith {}
		};
		
	_diff = 1;
	_route0 = +_route;
	_route = [];
	_ct = 0;
		
	while {(_diff > 0)} do
		{
		_cnt1 = count _route;
		_ref = _pos1;

		if (_cnt1 > 0) then
			{
			_ref = _route select ((count _route) - 1)
			};
			
		_dstRef = _ref distance _pos2;
		
			{
			_dst = _x distance _pos2;
			
			if (_dst < _dstRef) exitWith
				{
				_route set [(count _route),_x]
				}
			}
		foreach _route0;
		
		_cnt2 = count _route;
		_diff = _cnt2 - _cnt1
		};
		
	_last = (_route0 select ((count _route0) - 1));
	
	if not (_last in _route) then
		{
		_route set [(count _route),_last]
		};
								
	_route	 
	};

RYD_H_FlankingRoute = 
	{
	private ["_flanker","_flanked","_finalPos","_hideLevel","_center","_startPos","_angle","_lng","_amnt","_sectors","_hidden","_pos1","_dir","_rds","_pos2","_cl","_cost","_isLOS","_hidden0","_close","_clean",
	"_hid","_cluster","_env","_xEnv","_yEnv","_p1","_p2","_p3","_p4","_borderS","_cnt","_middleP","_borderS0","_dst0","_dst1","_pos","_dst2","_dst3","_route1","_middlePArr","_middleP2","_route2","_route3",
	"_route","_route0","_finalS","_diff","_cnt1","_cnt2","_ix","_step","_exit"];
	
	//_stoper = time;
	
	_flanker = _this select 0;
	_flanked = _this select 1;
	_finalPos = _this select 2;
	_hideLevel = _this select 3;
	
	_center = _flanked;
	
	if ((typeName _center) == "OBJECT") then
		{
		_center = getPosATL _flanked
		};
		
	_startPos = _flanker;

	if ((typeName _startPos) == "OBJECT") then
		{
		_startPos = getPosATL _flanker
		};
	
	_angle = [_center,_startPos,0] call RYD_H_AngTowards;
	
	_lng = (_finalPos distance _flanked) * 4; 
	_amnt = 20;
	
	while {((_lng/_amnt) < 20)} do
		{
		_amnt = ceil (_amnt/1.5)
		};
		
	if (_amnt < 10) then {_amnt = 10};
			
	_sectors = [_center,_lng,_angle,_amnt,_hunter] call RYD_H_Sectorize;

	RYD_Hunter_FSM_handle setFSMVariable ["RYD_H_Sectors" + (str _hunter),_sectors];
		
	_hidden = [];
	
	_pos1 = eyepos _flanked;
	_pos1 = [_pos1 select 0,_pos1 select 1,(_pos1 select 2) + _hideLevel];
	_dir = getDir _flanked;
	_rds = ((size (_sectors select 0)) select 0) * 2.1;

		{
		_pos2 = position _x;
		_pos2 = ATLToASL _pos2;
		_pos2 = [_pos2 select 0,_pos2 select 1,(_pos2 select 2) + _hideLevel];
		_cl = "ColorBlue";
		_cost = 0;

		_isLOS = [_pos1,_pos2,_flanker,_flanked] call RYD_H_LOSCheck;
		if (((position _flanked) distance (position _x)) < _rds) then {_isLOS = true};
		
		if (_isLOS) then 
			{
			_cost = 1;
			_cl = "ColorRed"
			};
						
		//_mark = "sector_" + (str _pos2);
		//_mark = [_mark,position _x,_cl,"RECTANGLE",size _x,direction _x,0.5,"Solid",""] call RYD_H_Marker;
		if not (_isLOS) then {_hidden set [(count _hidden),_x]};
		//_x setVariable ["Over_Mark",_mark];
		RYD_Hunter_FSM_handle setFSMVariable ["Cost_Loc" + (str _x),_cost]
		}
	foreach _sectors;
	
	_rds = ((size (_sectors select 0)) select 0) * 3;
	
	_hidden0 = +_hidden;
	
		{
		_close = [_x,_rds] call RYD_H_FindNearSec;
		_clean = true;
		
		_hid = _x;

			{
			if ((RYD_Hunter_FSM_handle getFSMVariable ("Cost_Loc" + (str _x))) > 0) exitWith
				{
				if not ((RYD_Hunter_FSM_handle getFSMVariable ("Cost_Loc" + (str _x))) == 1000) then
					{
					_clean = false;
					_hidden = _hidden - [_hid]
					}
				}
			}
		foreach _close;
		}
	foreach _hidden0;
	
	_hidden0 = nil;

	_cluster = [(_sectors - _hidden),((size (_sectors select 0)) select 0) * 2.1,position _flanked] call RYD_H_MainCluster;
	
	_env = [_cluster] call RYD_H_SecEnvelope;

	_xEnv = _env select 0;
	_yEnv = _env select 1;
	
	_p1 = [_xEnv select 0,_yEnv select 0,0];
	_p2 = [_xEnv select 0,_yEnv select 1,0];
	_p3 = [_xEnv select 1,_yEnv select 1,0];
	_p4 = [_xEnv select 1,_yEnv select 0,0];
	
		/*{
		_mark = ["mark" + (str (random 1000)),_x,"ColorYellow","ICON",[0.8,0.8],0,1,"mil_box",""] call RYD_H_Marker;
		}
	foreach [_p1,_p2,_p3,_p4];*/

	_borderS = [];
	
		{
		_close = [_x,_rds] call RYD_H_FindNearSec;
		_cnt = {(_x in _cluster)} count _close;
		if (_cnt > 0) then
			{
			if (_cnt < 4) then
				{
				_borderS set [(count _borderS),_x]
				}
			}
		}
	foreach _sectors;
	
	_middleP = [(position _flanker),[_p1,_p2,_p3,_p4]] call RYD_H_FindClosestB;
//_mark = [_middleP,_middleP,"markCapture","ColorGreen","ICON","mil_box","A","",[0.8,0.8]] call RYD_H_Mark;	
	_borderS0 = + _borderS;
	_borderS = [];
	_dst0 = _startPos distance _middleP;
	_dst1 = _finalPos distance _middleP;
		
		{
		_pos = position _x;
		_dst2 = _pos distance _startPos;

		if (_dst2 <= _dst0) then
			{
			_dst3 = _pos distance _finalPos;

			if (_dst3 >= _dst1) then
				{
				_borderS set [(count _borderS),_x]
				}
			}		
		}
	foreach _borderS0;
					
	_route1 = [_startPos,_middleP,_sectors,_hidden,_flanked,_borderS,false] call RYD_H_CheapestRoute;
			
	_middlePArr = [_p1,_p3];
	
	if (((_p1 distance _middleP) == 0) or ((_p3 distance _middleP) == 0)) then
		{
		_middlePArr = [_p2,_p4]
		};
		
	_middleP2 = _middlePArr select 0;
	
	if ((_middleP2 distance _finalPos) > ((_middlePArr select 1) distance _finalPos)) then
		{
		_middleP2 = _middlePArr select 1
		};
//_mark = [_middleP2,_middleP2,"markCapture","ColorGreen","ICON","mil_box","B","",[0.8,0.8]] call RYD_H_Mark;		
	_borderS = [];
	_dst0 = _startPos distance _middleP;
	_dst1 = _middleP2 distance _middleP;
	
		{
		_pos = position _x;
		_dst2 = _pos distance _startPos;
		if (_dst2 >= _dst0) then
			{
			_dst3 = _pos distance _middleP2;
			
			if (_dst3 <= _dst1) then
				{
				_borderS set [(count _borderS),_x]
				}
			}		
		}
	foreach _borderS0;

	_route2 = [_middleP,_middleP2,_sectors,_hidden,_flanked,_borderS,false] call RYD_H_CheapestRoute;
	
	_borderS = [];
	_dst0 = _middleP distance _middleP2;
	_dst1 = _finalPos distance _middleP2;
	
		{
		_pos = position _x;
		_dst2 = _pos distance _middleP;
		if (_dst2 >= _dst0) then
			{
			_dst3 = _pos distance _finalPos;
			
			if (_dst3 <= _dst1) then
				{
				_borderS set [(count _borderS),_x]
				}
			}		
		}
	foreach _borderS0;
	
	_route3 = [_middleP2,_finalPos,_sectors,_hidden,_flanked,_borderS,true] call RYD_H_CheapestRoute;
		
	_route1 = _route1 - [_route2 select 0];
	_route2 = _route2 - [_route3 select 0];
	_route  = _route1 + _route2 + _route3;

	_route0 = +_route;
	
		{
		_pos = position _x;
		if (surfaceIsWater [_pos select 0,_pos select 1]) then
			{
			_route set [(count _route),"Del"]
			}
		}
	foreach _route0;
	
	_route = _route - ["Del"];
		
	_finalS = _route select ((count _route) - 1);
				
	_diff = 1;
	
	while {(_diff > 0)} do
		{
		_route0 = +_route;
		_cnt1 = count _route;

			{
			_ix = _foreachIndex;
			_step = _x;
			_dst1 = _step distance _finalPos;
			_exit = false;
			
				{
				if (_foreachIndex > _ix) then
					{
					_dst2 = _step distance _x;
					
					if (_dst2 > _dst1) exitWith
						{
						_route = _route - [_x];
						_exit = true
						}
					};
					
				if (_exit) exitWith {}
				}
			foreach _route0;
			
			if (_exit) exitWith {}
			}
		foreach _route0;
		
		_cnt2 = count _route;
		_diff = _cnt1 - _cnt2
		};
		
	if not (_finalS in _route) then
		{
		_route set [(count _route),_finalS]
		};
			
		/*{
		_mark = ["mark" + (str (random 1000)),position _x,"ColorBlack","ICON",[1,1],0,1,"mil_dot",(str _foreachIndex)] call RYD_H_Marker;
		}
	foreach _route;*/
	
	_route0 = +_route;
	_route = [];
	
		{
		_route set [(count _route),position _x]
		}
	foreach _route0;
	
		{
		deleteLocation _x
		}
	foreach (RYD_Hunter_FSM_handle getFSMVariable ("RYD_H_Sectors" + (str _hunter)));
	
	RYD_Hunter_FSM_handle setFSMVariable ["RYD_H_Sectors" + (str _hunter),nil];
		
	//hint format ["czas: %1",time - _stoper];
	
	_route
	};