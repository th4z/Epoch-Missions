#include "missions.sqf"
// Active Mission List
						// Name							Recurring
active_mission_list =  [
						[mission_kamenka,				true],
						[mission_balota_airfield,		true],
						[mission_cherno_outside, 		true],
						[mission_cherno_hospital, 		true],
						[mission_cherno_hostpital2,		true],
						[mission_cherno_firestation,	true],
						[mission_cherno_shop,			true],
						[mission_cherno_petrol,			true],
						[mission_electro_petrol,		true],
						[mission_electro_school,		true],
						[mission_electro_shop,			true]					
						];

// List of possible Vehicles & Count for AI to spawn with
//		These vehicles are added to database
//			These vehicles should have a higher count than epoch dynamic vehicles..
//				Otherwise epoch will have spawned them before Mission System gets a chance to.
//					Ideally made for patrols or missions with a disabled Vehicle						
dynamic_ai_vehicles = [];