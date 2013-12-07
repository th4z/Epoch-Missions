//Sneaky Hunter AI 1.0 (FSM version) by Rydygier

//Sneaky Hunter AI setup

call compile preprocessFile "Predator_fnc.sqf";	
call compile preprocessFile "Predator_aux_fnc.sqf";

hunter1 setPos ([(getPosATL hunted1),60,150] call RYD_H_RandomAroundMM);

//Parameters: hunted unit, max trail lifetime in seconds (older "footprints" will be removed)

{[_x,3600] spawn RYD_H_MyTrail} foreach (units (group Hunted1));

//Parameters: hunter unit, smell sensitivity, eyes sensitivity [light factor,movement factor],hunted unit(s),loiter radius if no prey nor trail known if 0 - unlimited, force of the hunter's strike multiplier.

RYD_Hunter_FSM_handle = [hunter1,3,[1.5,1.5],(units (group hunted1)),200,1] execFSM "RYD_Hunter.fsm";

//mission setup

setViewDistance 700;

Hunter1 setPos ([(getPosATL Hunted1),60,150] call RYD_H_RandomAroundMM);

//Debug option

RYDHnt_Dbg = true;

if (RYDHnt_Dbg) then
	{
	_mark = [(getPosATL hunter1),hunter1,"markCapture","ColorPink","ICON","mil_dot","","",[0.8,0.8]] call RYD_H_Mark;
	_mark2 = [(getPosATL hunted1),hunted1,"markCapture","ColorBlue","ICON","mil_dot","","",[0.8,0.8]] call RYD_H_Mark;

	while {true} do
		{
		sleep 0.2;
		_mark setMarkerPos (getPosATL hunter1);
		_mark2 setMarkerPos (getPosATL hunted1);
		_mark2 setMarkerText (format ["%1 - %2",(hunted1 knowsAbout hunter1),round (hunted1 distance hunter1)])
		}
	};