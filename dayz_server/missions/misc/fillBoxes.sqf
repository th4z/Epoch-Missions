private ["_crate", "_loot_type", "_loot", "_chance", "_item", "_type", "_amount", "_mags"];

_crate = _this select 0;
_loot_type = _this select 1;

clearWeaponCargoGlobal _crate;
clearMagazineCargoGlobal _crate;

// Item | Type | Chance | Amount
if (_loot_type == "Random") then {
	_loot_type = ["Building Supplies", "Medical Supplies", "Miltary Supplies", "Miltary Supplies", "Money", "Rare", "Residental Supplies"] call BIS_fnc_selectRandom;
};

switch(_loot_type) do
{
	case "Building Supplies":
	{
		_loot = [
				["ItemToolbox", 	 "weapon", 0.3, 5],
				["ItemMatchbox", 	 "weapon", 0.3, 5],
				["ItemJerrycan", 	   	   "", 0.5, 5],
				["ItemFuelBarrel", 		   "", 0.5, 5],
				["ItemSledge",		 "weapon", 0.5, 2],
				["PartPlywoodPack","magazine", 0.8, 10],
				["CinderBlocks",	"magazine",0.8, 10],
				["MortarBucket",	"magazine",0.8, 10],
				["ItemFuelPump",	"magazine",0.5, 5],
				["ItemTankTrap",	"magazine",0.5, 5],
				["PartGeneric",	"magazine",0.5, 5],
				
				
				
				["Remington870_lamp", 	  "weapon",  0.8, 1],
				["PipeBomb", 					"",  0.2, 4],
				["ItemComboLock",				"",  0.2, 4],
				

				["DZ_ALICE_Pack_EP1", "backpack", 0.4, 3],

				["HandChemGreen", 		"", 0.5, 10],
				["HandRoadFlare", 		"",	1.0, 10],
				["HandChemRed", 		"", 0.5, 10]];
	};
		
	case "Medical":
	{
		_loot = [
				["ItemAntibiotic",	"", 0.5, 5],
				["ItemMorphine", 	"", 0.5, 5],
				["ItemSodaRbull", 	"", 0.5, 5],

				
				
				["ItemBandage", 	"", 0.8, 10],
				["ItemPainkiller", 	"", 0.8, 5],
				["ItemBloodbag", 	"", 0.5, 10],
				["ItemHeatPack", 	"", 0.5, 10],				
				["ItemWire", 	"", 0.5, 4],
				

				["glock17_EP1", 	"weapon",  0.8, 1],
				["MakarovSD", 		"weapon",  0.8, 1],
				["MR43", 		"weapon",  0.8, 2],
				

				["DZ_Czech_Vest_Puch", "backpack", 0.4, 4],

				["FoodCanBakedBeans", 		"", 1.0, 10],
				["FoodCanUnlabeled", 		"", 1.0, 10],
				["ItemWaterbottle", 		"", 0.5, 10]];
	};
		
	case "Miltary":
	{
		_loot = [
				["ItemToolbox", 	"weapon", 0.5, 5],
				["ItemMatchbox", 	"weapon", 0.5, 5],
				["ItemCompass",		"weapon", 0.5, 5],
				["ItemMap",			"weapon", 0.5, 5],
				["ItemGPS",			"weapon", 0.3, 5],
				["ItemRadio",		"weapon", 0.3, 5],
				["ItemEtool", 	   "weapon", 0.3, 5],
				["UZI_SD_EP1",	   "weapon", 0.6, 5],
				["M249_DZ",		   "weapon", 0.2, 5],
				
				["ItemBandage", 		 "", 0.8, 10],
				["ItemPainkiller", 		 "", 0.8, 5],
				["ItemBloodbag", 		 "", 0.5, 10],

				["glock17_EP1", 	"weapon",  0.8, 2],
				["MakarovSD", 		"weapon",  0.8, 2],
				["UZI_EP1", 		"weapon",  0.8, 2],
				["Sa61_EP1", 		"weapon",  0.6, 3],
				
				["30Rnd_556x45_Stanag", 		"",  0.4, 10],
				["30Rnd_556x45_StanagSD", 		"",  0.2, 10],
				
				["30Rnd_545x39_AK", 		"",  0.4, 10],
				["30Rnd_545x39_AKSD", 		"",  0.4, 10],
				
				
				

				["DZ_LargeGunBag_EP1", "backpack", 0.4, 1],

				["FoodCanBakedBeans", 	"", 1.0, 10],
				["HandRoadFlare", 		"", 1.0, 10],
				["HandGrenade_west", 	"", 0.5, 10]];
	};
		
	case "Money":
	{
		_loot = [
				["ItemToolbox", 	"weapon", 0.5, 5],
				["ItemMatchbox", 	"weapon", 0.5, 5],
				
				["ItemBandage", 		 "", 0.8, 10],
				["ItemPainkiller", 		 "", 0.8, 5],
				["ItemBloodbag", 		 "", 0.5, 10],

				["ItemSilverBar", 	"",  0.8, 8],
				["ItemGoldBar",		"",  0.8, 4],

				["DZ_Backpack_EP1", "backpack", 0.4, 1],

				["FoodCanBakedBeans", 		"", 1.0, 10],
				["HandRoadFlare", 			"", 1.0, 10],
				["ItemGoldBar10oz", 		"", 0.5, 4]];
	};
	
	case "Rare":
	{
		_loot = [
				["ItemToolbox", 	"weapon",	0.5, 5],
				["ItemMatchbox", 	"weapon",	0.5, 5],
				["ItemGenerator", 		  "",	0.5, 5],
				["ItemKeyKit", 		 "weapon", 	0.5, 5],
				["ItemBandage", 		 "", 	0.8, 10],
				["ItemPainkiller", 		 "", 	0.8, 5],
				["ItemBloodbag", 		 "", 	0.5, 10],

				["glock17_EP1", 	"weapon",	0.8, 1],
				["G36_C_SD_camo", 	"weapon",	0.6, 3],
				
				["MakarovSD", 		"weapon",	0.8, 1],
				["NVGoggles",		"weapon",	0.8, 1],

				["DZ_British_ACU", "backpack", 0.4, 1],

				["FoodCanBakedBeans", 		"", 1.0, 10],
				["HandRoadFlare", 			"", 1.0, 10],
				["ItemSilverBar", 		"", 0.5, 10]];
	};
		
	case "Residental":
	{
		_loot = [
				["ItemMatchbox", 	"weapon", 0.5, 5],
				["ItemKnife",		"weapon", 0.5, 5],
				
				["ItemBandage", 		 "", 0.8, 10],
				["ItemPainkiller", 		 "", 0.8, 5],

				["ItemSodaMdew", 		 	"", 0.5, 10],
				["ItemSodaRbull", 			"", 0.5, 10],
				["ItemSodaOrangeSherbet", 	"", 0.5, 10],
				["FoodNutmix", 	"", 0.5, 10],
				["FoodCanBakedBeans", 		"", 1.0, 10],
				["FoodMRE", 		"", 1.0, 10],
				
				
				["PartPlankPack", 	"magazine", 0.5, 5],
				["ItemFishingPole",	  "weapon", 0.5, 5],
				["ItemLightBulb",			"", 0.5, 5],

				["Winchester1866", 		"weapon",  0.8, 3],

				["DZ_Backpack_EP1", "backpack", 0.4, 1],

				["HandRoadFlare", 			"", 1.0, 10],
				["HandGrenade_west", 		"", 0.5, 10]];
	};
		
	default
	{
		_loot = [
				["ItemToolbox", 	"weapon", 0.5, 5],
				["ItemMatchbox", 	"weapon", 0.5, 5],
				
				["ItemBandage", 		 "", 0.8, 10],
				["ItemPainkiller", 		 "", 0.8, 5],
				["ItemBloodbag", 		 "", 0.5, 10],

				["glock17_EP1", 		"weapon",  0.8, 1],
				["MakarovSD", 			"weapon",  0.8, 1],

				["DZ_Backpack_EP1", 	"backpack", 0.4, 1],

				["FoodCanBakedBeans", 		"", 1.0, 10],
				["HandRoadFlare", 			"", 1.0, 10],
				["ItemCopperBar", 		"", 0.5, 10]];
	};
};

// Item | Type | Chance | Amount
{
	diag_log format ["DEBUG MISSIONS: fillBoxes _x: %1", _x];
	_chance = (_x select 2);
	if ((random 1) < _chance) then {
		_item = (_x select 0);
		_type = (_x select 1);
		_amount = (_x select 3);
		switch (_type) do
		{
			case "weapon":
			{
				_amount = round(random _amount);
				_crate addWeaponCargoGlobal [_item, _amount];
				_mags = [] + getArray (configFile >> "cfgWeapons" >> _item >> "magazines");
				if ((count _mags) > 0) then
				{
					if (_mags select 0 == "Quiver") then { _mags set [0, "WoodenArrow"] }; // Prevent spawning a Quiver
					_crate addMagazineCargoGlobal [(_mags select 0), ((round(random 6))*_amount)];
				};
			};
			
			case "backpack":
			{
				_amount = round(random _amount);
				_crate addBackpackCargoGlobal [_item, _amount];
			};
			
			default
			{
				_amount = round(random _amount);
				_crate addMagazineCargoGlobal [_item, _amount];
			};
		};
	};
} forEach _loot;