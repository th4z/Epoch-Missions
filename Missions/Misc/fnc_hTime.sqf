private["_time","_val","_return","_rand","_bool","_tar"];
_high_value = _this select 0;
_low_value = _this select 1;

_rand = round(random (_high_value - _low_value));
_return = _low_value + _rand;

_return;
