private ["_marker", "_object"];

diag_log format ["DEBUG: Custom Plot Poles: _this %1", _this];
_object = _this select 0;
/*
_marker = createMarker [str(getpos(_object)), getpos(_object)];
_marker setMarkerShape "RECTANGLE";
_marker setMarkeralpha 0;
_marker setMarkerType "Flag";
_marker setMarkerBrush "Solid";
_marker setMarkerSize [200,200];
*/
Custom_Plot_Poles = Custom_Plot_Poles + [_object];
diag_log format ["DEBUG: Custom Plot Poles: %1", Custom_Plot_Poles];