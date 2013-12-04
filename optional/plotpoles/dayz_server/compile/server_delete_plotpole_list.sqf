private ["_last_index", "_index", "_item"];

_plotpole = _this;
_plotpole_pos = getpos(_plotpole);
_plotpole_name = ("Custom_Plot_Pole" + str(_plotpole_pos));

while {true} do {
	_last_index = count Custom_Plot_Poles;
	_index = 0;
	while {(_index < _last_index)} do
	{
		_item = (Custom_Plot_Poles select _index);
		if (_item == _plotpole_name) then {
			deleteMarker _plotpole_name;
			Custom_Plot_Poles set [_index, "delete me"];
			Custom_Plot_Poles = Custom_Plot_Poles - ["delete me"];			
			_index = _index - 1;
			_last_index = _last_index - 1;
		};
		_index = _index + 1;
	};
};