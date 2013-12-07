crate_add_loot = {
	private ["_iItem","_iClass","_iPos","_radius","_item","_itemTypes","_index","_weights","_cntWeights","_qty","_max","_tQty","_canType","_mags","_dateNow"];

	_iItem = 	_this select 0;
	_iClass = 	_this select 1;
	_crate =    _this select 2;

	switch (_iClass) do
	{
		default
		{
			_itemTypes = [] + ((getArray (missionconfigFile >> "cfgLoot" >> _iClass)) select 0);
			_index = dayz_CLBase find _iClass;
			_weights = dayz_CLChances select _index;
			_cntWeights = count _weights;
			_qty = 3;
			_max = 1 + round(random 3);
			while {_qty < _max} do
			{
				_tQty = 1 + round(random 1);
				_index = floor(random _cntWeights);
				_index = _weights select _index;
				_canType = _itemTypes select _index;
				_crate addMagazineCargoGlobal [_canType,_tQty];
				_qty = _qty + _tQty;
			};
			if (_iItem != "") then
			{
				_crate addWeaponCargoGlobal [_iItem,random(4)];
			};
		};
		case "single":
		{
			_amount = round(random 5);
			_itemTypes = [] + ((getArray (missionconfigFile >> "cfgLoot" >> _iItem)) select 0);
			_index = dayz_CLBase find _iItem;
			_weights = dayz_CLChances select _index;
			_cntWeights = count _weights;
				
			_index = floor(random _cntWeights);
			_index = _weights select _index;
			_canType = _itemTypes select _index;
			
			_crate addMagazineCargoGlobal [_canType,_amount];
			_crate addMagazineCargoGlobal ["ItemSilverBar",_amount];
			
		};
		case "backpack":
		{
			_amount = round(random 2);
			_itemTypes = [] + ((getArray (missionconfigFile >> "cfgLoot" >> _iItem)) select 0);
			_index = dayz_CLBase find _iItem;
			_weights = dayz_CLChances select _index;
			_cntWeights = count _weights;
			_index = floor(random _cntWeights);
			_index = _weights select _index;
			_iItem = _itemTypes select _index;
			
			_crate addBackpackCargoGlobal [_iItem,1];
		};
		case "cfglootweapon":
		{
			_itemTypes = [] + ((getArray (missionConfigFile >> "cfgLoot" >> _iItem)) select 0);
			_index = dayz_CLBase find _iItem;
			_weights = dayz_CLChances select _index;
			_cntWeights = count _weights;
				
			_index = floor(random _cntWeights);
			_index = _weights select _index;
			_iItem = _itemTypes select _index;

			if (_iItem == "Chainsaw") then {
				_iItem = ["ChainSaw","ChainSawB","ChainSawG","ChainSawP","ChainSawR"] call BIS_fnc_selectRandom;
			};

			//Item is a weapon, add it and a random quantity of magazines
			_crate addWeaponCargoGlobal [_iItem,1];
			_mags = [] + getArray (configFile >> "cfgWeapons" >> _iItem >> "magazines");
			if ((count _mags) > 0) then
			{
				if (_mags select 0 == "Quiver") then { _mags set [0, "WoodenArrow"] }; // Prevent spawning a Quiver
				if (_mags select 0 == "20Rnd_556x45_Stanag") then { _mags set [0, "30Rnd_556x45_Stanag"] };
				_crate addMagazineCargoGlobal [(_mags select 0), (round(random 2))];
			};
			
		};
		
		case "weapon":
		{
			_amount = round(random 3);
			_crate addWeaponCargoGlobal [_iItem,_amount];
			_mags = [] + getArray (configFile >> "cfgWeapons" >> _iItem >> "magazines");
			if ((count _mags) > 0) then
			{
				if (_mags select 0 == "Quiver") then { 
					_mags set [0, "WoodenArrow"] 
				};
				_crate addMagazineCargoGlobal [(_mags select 0), (_amount*(round(random 5)))];
			};
		};
		case "weaponnomags":
		{
			//_crate addWeaponCargoGlobal [_iItem,1];
			_amount = round(random 6);
			_crate addMagazineCargoGlobal [_iItem, _amount];
		};
		case "magazine":
		{
			_amount = round(random 6);
			_crate addMagazineCargoGlobal [_iItem,_amount];
		};
		case "object":
		{
			_amount = round(random 5);
			_crate addMagazineCargoGlobal ["ItemGoldBar", _amount];
		};
	};
};


private ["_crate", "_loot_type", "_loot", "_chance", "_item", "_type", "_amount", "_mags"];

_crate = _this select 0;
_lootTable = _this select 1;

if (_lootTable == "Random") then {
	_lootTable = mission_loot_tables call BIS_fnc_selectRandom;
};

_config = 		missionConfigFile >> "CfgBuildingLoot" >> _lootTable;
_itemTypes =	[] + getArray (_config >> "itemType");
_index =        dayz_CBLBase find toLower(_lootTable);
_weights =		dayz_CBLChances select _index;
_cntWeights = count _weights;


_num = 7;
_amount = round(random 8);


for "_x" from 1 to (_num + _amount) do {
	//create loot
	sleep 1;
	_index = floor(random _cntWeights);
	_index = _weights select _index;
	_itemType = _itemTypes select _index;
	[_itemType select 0, _itemType select 1, _crate] spawn crate_add_loot;
};