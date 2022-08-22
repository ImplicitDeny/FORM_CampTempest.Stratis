// Affiche les stats du respirateur, actualisation à chaque seconde
params["_unit", "_time"];

// Si on a un temps fourni, on affiche durant ce temps. Sinon c'est que c'est un ATH permanent.
_condition = { goggles _unit isEqualTo "G_B_Diving" };
if!(_time isEqualTo -1) then {
	_condition = { _i < _time };
};

_i = 0; //timer, pas forcément utilisé.
// Boucle affichage
while _condition do {
	_lvl = _unit getVariable "LM_breath_lvl";

	// Affiche 0 si négatif
	if(_lvl < 0) then {
		systemChat ("Bellow zero level ! "+str _lvl);
		_lvl = 0;
	};

	// Ligne 1
	// Couleur de la barre
	_colorBar = switch(true) do {
		case (_lvl < 20): {'ff0000'}; //rouge
		case (_lvl < 40): {'f4bf42'}; //orange
		default {'00ff00'}; //vert
	};
	// Chaine restante
	_rest = "";
	_n = linearConversion [0, 100, _lvl, 1, 20];
	_n = ceil _n;
	for [{_i=1}, {_i< _n}, {_i=_i+1}] do { _rest = _rest + "=" };
	// Chaine consommée
	_conso = "";
	for [{_i=_n}, {_i<20}, {_i=_i+1}] do { _conso = _conso + "=" };
	_line1 = "[<t color='#%1'>%2</t><t color='#000000'>%3</t>] %4%5<br />";

	// Ligne 2
	// Couleur profondeur %6
	_depth = (eyePos _unit) select 2; //%7
	_colorDepth = switch(true) do {
		case (_depth < -35): {'ff0000'}; //rouge
		case (_depth < -25): {'f4bf42'}; //orange
		default {'00ff00'}; //vert
	};
	// Légence inspiration oxygène %8
	_bag = _unit getVariable "LM_breath_bag";
	_inspi = switch(true) do {
		case (_bag < 0.3): {"<t color='#ff0000'>critical !</t>"}; //rouge
		case (_bag < 0.38): {"<t color='#f49b41'>very low !</t>"}; //orange foncé
		case (_bag < 0.45): {"<t color='#f4bf42'>low, warn.</t>"}; //orange
		default {"<t color='#00ff00'>nominal</t>"}; //vert
	};
	_line2 = "Depth : <t color='#%6'>%7m</t>  |  Oxy. : %8<br/>";

	// Ligne 3, TODO
	_line3 = "Status : <t color='#00ff00'>NORM</t>  |  Diag. : NONE";

	// Assemblage
	_output = _line1 + _line2 + _line3;
	_output = format [_output, _colorBar, _rest, _conso, (_lvl toFixed 2), "%", _colorDepth, _depth toFixed 2, _inspi];

	// Affichage
	hintSilent parseText _output;

	// Si on a un temps fini, on augmente le timer
	if!(_time isEqualTo -1) then {_i = _i+1};
	sleep 1;
};

hintSilent "";