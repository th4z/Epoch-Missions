private ["_last_index", "_index", "_item"];
_remove_item = _this;

while {true} do {
	// Remove AI Group + Map Marker if all units are dead
	_last_index = count Custom_Plot_Poles;
	_index = 0;
	while {(_index < _last_index)} do
	{
		_item = (Custom_Plot_Poles select _index);
		if (_remove_item == _item) then {
			deleteMarker str(getPos _remove_item);
			Custom_Plot_Poles set [_index, "delete me"];
			Custom_Plot_Poles = Custom_Plot_Poles - ["delete me"];			
			_index = _index - 1;
			_last_index = _last_index - 1;
		};
		_index = _index + 1;
	};
};