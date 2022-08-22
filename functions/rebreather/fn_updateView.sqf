// Effet d'évanouissement
params["_unit"];

// Déficit en oxygène
_deficit = 0.5-(_unit getVariable "LM_breath_bag");

// Profondeur dangereuse
_prof = 30 + (eyePos _unit select 2);

// Récupération de l'effet
_pp = player getVariable "LM_narcose";

// Conversion déficit et profondeur en effet visuel
_effet = linearConversion [0, 0.5, _deficit, 0.5, 1, true];
if(_effet == 0.5 && _prof < 0) then { _effet = linearConversion [0, 20, abs _prof, 0.5, 1, true] }; //s'il n'y a pas de déficit on regarde la profondeur

if(eyePos _unit select 2 < 0) then {
	// Mise à jour effet visuel
	_pp ppEffectAdjust [ 
		1,
		1-(_effet),
		0, 
		[0, 0, 0, 0], 
		[1, 1, 1, 1], 
		[0.5, 0.5, 0.5, 1],
		[1, 1, 0, 0, 0, 1-(_effet), 1-(_effet)]
	];
	_pp ppEffectCommit 0.9;
} else {
	_pp ppEffectAdjust [ 
		1,
		1,
		0, 
		[0, 0, 0, 0], 
		[1, 1, 1, 1], 
		[0.5, 0.5, 0.5, 1],
		[1, 1, 0, 0, 0, 1, 1]
	];
	_pp ppEffectCommit 5;
};