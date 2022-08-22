params["_unit"];

systemChat "Entering simulation";

// Simulation démarre
_unit setVariable ["LM_breath_on", true];

// Simulation active
while { _unit getVariable "LM_breath_on" } do {
	// Boucle diminution air
	[_unit] call LM_fnc_breath; //respiration joueur
	sleep 0.5;
	[_unit] call LM_fnc_rebreath; //compensation
	sleep 0.5;

	// Vitesse ascensionnelle
	//systemChat str (velocity _unit select 2);

	// Mise à jour vision
	[_unit] call LM_fnc_updateView;

	// Dysfonctionnement random
	[_unit] call LM_fnc_rebreathBug;

	//Condition de sortie
	if(getPosASLW _unit select 2 > 0.5) then { _unit setVariable ["LM_breath_on", false] };
};

systemChat "Exiting simulation";

//[_unit, false] call ace_medical_fnc_setUnconscious;