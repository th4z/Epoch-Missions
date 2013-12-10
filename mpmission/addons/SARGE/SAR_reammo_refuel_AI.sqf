// =========================================================================================================
//  SAR_AI - DayZ AI library
//  Version: 1.5.0 
//  Author: Sarge (sarge@krumeich.ch) 
//
//		Wiki: to come
//		Forum: http://opendayz.net/#sarge-ai.131
//		
// ---------------------------------------------------------------------------------------------------------
//  Required:
//  UPSMon  (special SARGE version)
//  SHK_pos 
//  
// ---------------------------------------------------------------------------------------------------------
//   SAR_reammo_refuel_AI.sqf
//   last modified: 28.5.2013
// ---------------------------------------------------------------------------------------------------------

// Refuel and Reammo functions for AI infantry and AI in vehicles

private ["_ai","_sleeptime","_veh_weapons","_vehicle","_weapons","_reloadmag","_magazintypes","_legit_weapon","_weap_obj","_loop"];

if (!isServer) exitWith {}; // only run this on the server

_ai = _this select 0;

_magazintypes =[];
_reloadmag = false;
_weapons = weapons _ai;

_sleeptime = SAR_REAMMO_INTERVAL;
_loop = 0;
    
while {alive _ai} do {
    
    _vehicle = vehicle _ai;

    if(_vehicle != _ai) then { // NPC in vehicle, we are only reloading vehicle ammo and refueling the vehicle if needed
		if (_loop == 0) then {
			//diag_log (" ");
			_veh_ai_role = (assignedVehicleRole _ai);
			//diag_log format ["DEBUG: _veh_ai_role: %1", _veh_ai_role];
			if ((count _veh_ai_role) > 1) then {
				_turretPath = ((assignedVehicleRole _ai) select 1);
				//diag_log format ["DEBUG: _turretPath: %1", _turretPath];
				_weaponsTurret = _vehicle weaponsTurret (_turretPath);
				//diag_log (" ");
				if ((count _weaponsTurret) > 0) then {
					//diag_log format ["DEBUG: _weaponsTurret: %1", _weaponsTurret];
					{
						_magazintypes = getArray (configFile >> "CfgWeapons" >> _x >> "magazines");
						//diag_log format ["DEBUG: _magazintypes: %1", _magazintypes];
						_ammo = _vehicle ammo _x;
						//diag_log format ["DEBUG: _ammo: %1", _ammo];
						_mags = _vehicle magazinesTurret _turretPath;
						//diag_log format ["DEBUG: _mags: %1", _mags];
						if (_ammo < 11) then {
							//diag_log ("DEBUG: removing ammo + reloading");
							if ((count _mags) > 0) then {
								_vehicle removeMagazinesTurret [(_mags select 0), _turretPath];
							};
							_vehicle addMagazineTurret [(_magazintypes select 0), _turretPath];
							reload _vehicle;
						};
					} forEach _weaponsTurret;
				};		
			};
			
			if(fuel _vehicle < 0.2) then {
				_vehicle setFuel 1;
			};
			_loop = _loop + 1;
		} else {
			if (_loop > 2) then {
				_loop = 0;
			} else {
				_loop = _loop + 1;
			};
		};

    } else { // NPC not in a vehicle
        
        // loop through weapons array
        {
            // check if weapon rifle exists on AI
            if([_x,"Rifle"] call SAR_isKindOf_weapon) then {

                _reloadmag = true;
                _magazintypes = getArray (configFile >> "CfgWeapons" >> _x >> "magazines");
                
                // loop through valid magazines of weapon and check if there is a magazine for that weapon on the AI
                {
                    if (_x in magazines _ai) then {
                        _reloadmag = false;
                    };
                } foreach _magazintypes;
                
                if (!(someAmmo _ai) || {_reloadmag})  then {
                    _ai removeMagazines (_magazintypes select 0);
                    _ai addMagazine (_magazintypes select 0);
					_ai addMagazine (_magazintypes select 0);
					_ai addMagazine (_magazintypes select 0);
                };
            };

            if([_x,"Pistol"] call SAR_isKindOf_weapon) then {

                _reloadmag = true;
                _magazintypes = getArray (configFile >> "CfgWeapons" >> _x >> "magazines");
                // loop through valid magazines of weapon and check if there is a magazine for that weapon on the AI
                {
                    if (_x in magazines _ai) then {
                        _reloadmag = false;
                    };
                } foreach _magazintypes;
                
                if (!(someAmmo _ai) || {_reloadmag})  then {
                    _ai removeMagazines (_magazintypes select 0);
                    _ai addMagazine (_magazintypes select 0);
					_ai addMagazine (_magazintypes select 0);
                };
            };
            
        } foreach _weapons;
    };
    sleep _sleeptime;
};