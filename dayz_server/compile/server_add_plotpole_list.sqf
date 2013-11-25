private ["_marker", "_object"];

diag_log format ["DEBUG: Custom Plot Poles Adding: _this %1", _this];
_plotpole = _this select 0;

_plotpole_pos = getpos(_plotpole);
_plotpole_name = ("Custom_Plot_Pole" + str(getpos(_plotpole_pos)));
_plotpole_marker =  createMarkerLocal [_plotpole_name, _plotpole_pos];
Custom_Plot_Poles = Custom_Plot_Poles + [_plotpole_name];

diag_log format ["DEBUG: Custom Plot Poles: %1", Custom_Plot_Poles];