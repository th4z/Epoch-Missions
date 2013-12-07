Sneaky Hunter AI 1.1 by Rydygier

Changelog:

1.1

- minor code fixes.


1. Description

SH is an AI algorithm that simulates animal-like hunting behaviour of controlled unit (Hunter) against chosen units (Prey). 

This code does some heavy calculations, was tested for single Hunter, and this is recommended number of controlled units. 

SH AI is designated as opponent for player, but should work well also against AI. 

Hunter has to his disposal two customizable senses: sight and smell. 

Sight is specified by two parameters: light sensitivity and movement sensitivity. It decides, how easily Hunter will spot the Prey according on daytime, weather, size, speed, background (sky or not, surrounding terrain) and knowledge factor (memory). 

Smell helps to follow not visible Prey by its trail. Each Prey will leave "footprints", that Hunter can scent. Old footprints will be erased, also rain gives small chance for removing some parts of the trail. Smell (range) is strongly affected by wind (direction and strength).

If there is no Prey nor trail known, Hunter will loiter randomly. 

If Hunter see the Prey, his behaviour depends on situation. His goal is surprise attack, prefferably from behind. Will charge anyway, if close, but otherwise will approach, fast, or stealty, only, when flanking the Prey (out of Prey's FOV). If catched in the FOV depends on situation can hide low or run out of LOS, then try to outflank keeping out of sight. 

Is most dangerous at night, in the dense forest when visiblity is poor. 

Hunter strikes with bare hands (melee). 


2. Usage

Package contains two demo missions, one per code version (pure SQF and FSM&SQF mix, both should give same or nearly same effect, just different implementation), that need Lingor Island map. 

Init.sqf files of these missions provides some details about setup and default parameters along with some simple debug option for testing purposes in form of map markers. 


Code preparing for both versions:

call compile preprocessFile "Predator_fnc.sqf";	
call compile preprocessFile "Predator_aux_fnc.sqf";

Exemplary code launch for SQF:

//Parameters: hunted unit, max trail lifetime in seconds (older "footprints" will be removed)

{[_x,3600] spawn RYD_H_MyTrail} foreach (units (group Hunted1));

//Parameters: hunter unit, smell sensitivity, eyes sensitivity [light factor,movement factor],hunted unit(s),loiter radius if no prey nor trail known if 0 - unlimited, force of the hunter's strike multiplier.

[Hunter1,3,[1.5,1.5],(units (group Hunted1)),200,1] spawn RYD_H_Hunter;


Code launch for FSM version:

//Parameters: hunted unit, max trail lifetime in seconds (older "footprints" will be removed)

{[_x,3600] spawn RYD_H_MyTrail} foreach (units (group Hunted1));

//Parameters: hunter unit, smell sensitivity, eyes sensitivity [light factor,movement factor],hunted unit(s),loiter radius if no prey nor trail known if 0 - unlimited, force of the hunter's strike multiplier.

RYD_Hunter_FSM_handle = [hunter1,3,[1.5,1.5],(units (group hunted1)),200,1] execFSM "RYD_Hunter.fsm";



Put these missions where all unpacked missions are stored an preview in editor. You are a prey here, and Hunter's position is randomized each run. Try to survive and defeat him. Often you will sooner hear the Hunter than see. 

There is also optional, but recommended tiny addon, that will tweak used in tht demos Hunter unit (no danger FSM, no weapons, harder to spot for AI).

SH probably can do even better for some hipotetical custom animal model if agile and faster than human and not driven by own FSM. 

Enjoy

R. 