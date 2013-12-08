mission_add_hunter = {

	//RYD_Hunter_FSM_handle = [hunter1,mission_hunter_smell,mission_hunter_eyes,(units (group hunted1)),200,1] execFSM "\z\addons\dayz_server\addons\Missions\ai\RYD_Hunter\RYD_Hunter.fsm";
	//RYD_Hunter_FSM_handle ["_hunted", (units (group hunted1))];
};

mission_add_marker = {
	_marker_name = _this select 0;
	_position = _this select 1;
	_color = _this select 2;
	if ((count _this) > 3) then {
		mission_markers = mission_markers + [[_marker_name, _position, _color]];
	};
	
	_marker = createMarker [_marker_name, _position];
	_marker setMarkerColor _color;
	_marker setMarkerShape "ELLIPSE";
	_marker setMarkerBrush "Grid";
	_marker setMarkerSize [300,300];
};

mission_delete_marker = {
	_marker_name = _this select 0;
	
	deletemarker _marker_name;
	if ((count _this) > 1) then {
		_last_index = count mission_markers;
		_index = 0;
		while {(_index < _last_index)} do
		{
			_marker = mission_markers select _index;
			if ((_marker select 0) == _marker_name) then {
				mission_markers set [_index, "delete me"];
				mission_markers = mission_markers - ["delete me"];
				_index = _last_index;  // Map Markers Names are unique
			};
			_index = _index + 1;
		};
	};
};

mission_sync_markers = {
	{
		[_x select 0] call mission_delete_marker;
		_x call mission_add_marker;
	} forEach mission_markers;
};

mission_find_buildings = {
	private["type", "_list"];
	_type = _this select 0;
	_list = (getMarkerpos "center") nearObjects [_type,20000];
	_list
};


mission_timer = {
    private["_low_value","_high_value","_rand","_return"];
    _low_value = _this select 0;
    _high_value = _this select 1;
    
    _rand = round(random (_high_value - _low_value));
    _return = _low_value + _rand;
    
    _return;
};


mission_nearbyPlayers = {
    private ["_pos", "_isNearList", "_isNear"];
    _pos = _this select 0;
    
    _isNearList = _pos nearEntities ["CAManBase", mission_blacklist_players_range];
    _isNear = false;
    
    // Check for Players & Ignore SARGE AI
    if ((count(_isNearList)) > 0) then {
        {
            if (isPlayer _x) then {
                _isNear = true;
            };
        } forEach _isNearList;
    };
    
    if !(_isNear) then {
        _isNearList = _pos nearEntities [["LandVehicle", "Air"], mission_blacklist_players_range];
        {
            {
                if (isPlayer _x) then {
                    _isNear = true;
                };
            } forEach (crew _x);
        } forEach _isNearList;
    };
    _isNear
};

mission_nearbyBlackspot = {
    private ["_position", "_isNear", "_nearby"];
    _position = _this select 0;
    _isNear = false;
    
    _nearby = nearestObjects [_position, ["Plastic_Pole_EP1_DZ", "Info_Board_EP1"], mission_blacklist_range];
    
    if ((count _nearby) > 0) then {
        _isNear = true;
    };
    _isNear
};


mission_vehicle_pool = {
    private ["_veh_pool", "_vehicle", "_velimit", "_qty", "_veh_pool"];
    _veh_pool = [];
    {
        _vehicle = _x select 0;
        _velimit = _x select 1;
        _qty = {_x == _vehicle} count serverVehicleCounter;
        if (isNil {_qty}) then {
            _qty = 0;
        };
        if (_qty <= _velimit) then {
            _veh_pool = _veh_pool + [[_vehicle, _velimit]];
        };
    } forEach mission_dynamic_ai_vehicles;
    _veh_pool
};


mission_spawn_ai = {
    private ["_position","_snipers","_soldiers","_ai_setting","_marker2","_group2","_id1","_id2","_id3","_group1","_group3","_marker1","_marker3","_chance"];
    
	_marker_name = "SAR_mission_" + (_this select 0);
	_type = _this select 1;
    _position = _this select 2;
	_range = _this select 3;
    _snipers = _this select 4;
    _soldiers = _this select 5;
    _ai_setting = (_this select 6) call BIS_fnc_selectRandom;
	_group = objNull;

	
    _marker = createMarker [_marker_name, _position];
    _marker setMarkerShape "RECTANGLE";
    _marker setMarkeralpha 0;
    _marker setMarkerType "Flag";
    _marker setMarkerBrush "Solid";
    _marker setMarkerSize [_range, _range];
    missionNamespace setVariable [_marker_name, _marker];  
	
	switch (_type) do {
		case ("SAR_AI") :
		{
			_group = [missionNameSpace getVariable _marker_name, 4, _snipers, _soldiers, _ai_setting, false] call SAR_AI;
		};
		case ("SAR_AI_HELI"):
		{
			_group = [missionNameSpace getVariable _marker_name, 4, false] call SAR_AI_heli;
		};
		case ("SAR_AI_LAND"):
		{
			_group = [missionNameSpace getVariable _marker_name, 4, [(mission_patrol_land_vehicles call BIS_fnc_selectRandom)], [[1,1,1]], false] call SAR_AI_land;
		};
	};
	[_marker_name, _group]
};
	


mission_spawn_crates = {
    private ["_position", "_type", "_loot_type", "_crate"];
    
    _position = _this select 0;
    _type = _this select 1;
    _loot_type = _this select 2;
    
    _crate = createVehicle [_type, _position, [], 0, "CAN_COLLIDE"];
    clearWeaponCargoGlobal _crate;
    clearMagazineCargoGlobal _crate;
    [_crate, _loot_type] execVM "\z\addons\dayz_server\addons\missions\misc\fillBoxes.sqf";
    _crate setVariable ["Sarge", 1, true];  // Stop Server Cleanup Killing Box
    _crate
};


mission_spawn_vehicle = {
    private ["_vehicle_class", "_position", "_spawnDMG", "_dir", "_vehicle", "_objPosition", "_num", "_allCfgLoots", "_iClass", "_itemTypes", "_index", "_weights", "_cntWeights", "_index", "_itemType"];
    
    
    _vehicle_class = _this select 0;
    _position = _this select 1;
    _spawnDMG = _this select 2;
    
    diag_log format ["DEBUG: Spawn Vehicle Position: %1", _position];
    
    _dir = round(random 180);
    
    _vehicle = createVehicle [_vehicle_class, _position, [], 0, "CAN_COLLIDE"];
	clearWeaponCargoGlobal _vehicle;
	clearMagazineCargoGlobal _vehicle;
    _vehicle setdir _dir;
    _vehicle setpos _position;	
    _objPosition = getPosATL _vehicle;
    
    // Add 0-4 loots to vehicle using random cfgloots 
    _num = floor(random 4);
    _allCfgLoots = ["trash","civilian","food","generic","medical","military","policeman","hunter","worker","clothes","militaryclothes","specialclothes","trash"];
    
    for "_x" from 1 to _num do {
        _iClass = _allCfgLoots call BIS_fnc_selectRandom;
        
        _itemTypes = [] + ((getArray (configFile >> "cfgLoot" >> _iClass)) select 0);
        _index = dayz_CLBase find _iClass;
        _weights = dayz_CLChances select _index;
        _cntWeights = count _weights;
        
        _index = floor(random _cntWeights);
        _index = _weights select _index;
        _itemType = _itemTypes select _index;
        _vehicle addMagazineCargoGlobal [_itemType,1];
    };
    diag_log format ["DEBUG MISSION: Vehicle: _objPosition: %1", _objPosition];
    [_vehicle, [_dir, _objPosition], _vehicle_class, _spawnDMG, "0"] call server_publishVeh;
    [_vehicle, mission_despawn_timer_min] spawn mission_kill_vehicle;
    serverVehicleCounter set [count serverVehicleCounter, _vehicle_class];
};


mission_kill_vehicle_group = {
    private ["_units", "_vehicle"];
    _units = units (_this select 0);
    _vehicle = objNull;
    
    {
        if ((vehicle _x) != _x) exitWith {
            _vehicle = (vehicle _x);
        };
    } forEach _units;
    
    if ((_vehicle isKindOf "LandVehicle") || (_vehicle isKindOf "Air")) then {
        [_vehicle, mission_despawn_timer_min] spawn mission_kill_vehicle;		
    } else {
        diag_log format ["DEBUG: MISSIONS: Kill Vehicle Group: Unknown: _vehicle: %1", _vehicle];
    };
};


mission_kill_vehicle = {
    private ["_vehicle","_timer","_blowup","_exit","_vehicle_id"];
    
    _vehicle = _this select 0;
    _timer = time + (_this select 1);
    _blowup = true;
    _exit = false;
    
    waitUntil{
        sleep 1;
        if (alive _vehicle) then {
            {
                if ((isPlayer _x) && (_x distance _vehicle <= 10)) then {
                    _blowup = false;
                    _exit = true;
                };
            } forEach playableUnits;
        } else {
            _blowup = true;
            _exit = true;
        };
        if (time > _timer) then {
            _blowup = true;
            _exit = true;
        };
        _exit
    };
    
    [_vehicle, "all"] spawn server_updateObject;
    sleep 5;
    _vehicle_id = _vehicle getVariable ["ObjectID","0"];
    if (_blowup) then {
        diag_log format ["DEBUG: Mission Code: Killing Vehicle ID: %1", _vehicle_id];
        _vehicle setDamage 1;
        [_vehicle, "DAYZ MISSION SYSTEM"] call vehicle_handleServerKilled;
    } else {
        diag_log format ["DEBUG: Mission Code: Saving Vehicle ID: %1", _vehicle_id];
    };
};


mission_spawn = {
    private ["_chance","_position","_mission_type","_isNearPlayer","_isNearBlackspot"];
    diag_log ("DEBUG: Mission Code: Starting New Mission");
    
	_mission_id = _this select 0;
	
    // Spawn around buildings and 50% near roads
    _position = [];
    _mission_type = "";
    _chance = floor(random 100);
    
    // Try 10 Times to Find a Mission Spot
	_x = 1;
	while {(_x <= 20)} do {
        switch (true) do
        {
            case (_chance <= 25):
            {
                _mission_type = "Road";
                _position = RoadList call BIS_fnc_selectRandom;
                _position = _position modelToWorld [0,0,0];
                _position = [_position,0,100,5,0,2000,0] call BIS_fnc_findSafePos;
            };
            case (_chance <= 60):
            {
                _mission_type = "Building";		
                _position = BuildingList call BIS_fnc_selectRandom;
                _position = _position modelToWorld [0,0,0];
                _position = [_position,0,100,5,0,2000,0] call BIS_fnc_findSafePos;
            };
            case (_chance <= 80):
            {
                _mission_type = "Open Area";	
                _position = [getMarkerPos "center",0,5500,100,0,2000,0] call BIS_fnc_findSafePos;
            };
            case (_chance <= 100):
            {
				diag_log format ["DEBUG MISSIONS: ROADLIST: %1", RoadList];
                _mission_type = "Crash Site";	  
                _position = RoadList call BIS_fnc_selectRandom;
				diag_log format ["DEBUG MISSIONS: pos1: %1", _position];
                _position = _position modelToWorld [0,0,0];
				diag_log format ["DEBUG MISSIONS: pos2: %1", _position];
                _position = [_position,0,200,20,0,2000,0] call BIS_fnc_findSafePos;
				diag_log format ["DEBUG MISSIONS: pos3: %1", _position];
                //_position = [getMarkerPos "center",0,5500,100,0,2000,0] call BIS_fnc_findSafePos;
            };
        };

        diag_log format ["DEBUG POSITION: %1", _position];
		if ((count _position) == 2) then {			
			_isNearPlayer = [_position] call mission_nearbyPlayers;
			_isNearBlackspot = [_position] call mission_nearbyBlackspot;
			if ((!_isNearPlayer) && (!_isNearBlackspot)) then {
				_x = 20;
			} else {
				_position = [];
			};
		} else {
			_position = [];
		};
		_x = _x + 1;
		sleep 1;
    };
    
    // only proceed if two params otherwise BIS_fnc_findSafePos failed and may spawn in air
    if ((count _position) == 2) then {
        diag_log ("DEBUG: Mission Code: Position Good");
		switch (_mission_type) do 
		{
			case "Crash Site":
			{
				[_mission_id, _position] call mission_spawn_crash;
			};
			
			default
			{
				[_mission_id, _position, _mission_type] call mission_spawn_standard;
			};
		};
    } else {
        diag_log ("DEBUG: Mission Code: BIS fnc findsafepos failed giving up on mission");
    };
};