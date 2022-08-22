params["_unit"];

_unit setVariable ["LM_breath_on", false]; //simulation en cours
_unit setVariable ["LM_system_on", false]; //rebreather actif
_unit setVariable ["LM_breath_lvl", 100]; //quantité d'oxygène dans la bouteille
_unit setVariable ["LM_breath_bag", 0.5]; //"quantité" d'oxygène dans le sac à inspiration
//"quantité" cible d'oxygène dans le sac à inspiration
_unit setVariable ["LM_breath_opti", 0.5]; //NB : modifié uniquement pour dysfonctionnement. La normale pour la narcose est à 0.5

// Détection automatique de la mise en place du masque pour lancer la simulation.
_unit addEventHandler ["AnimChanged", { 
	params ["_unit"];
	if(getPosASLW _unit select 2 < 0.5 && !(_unit getVariable "LM_breath_on")) then { [_unit] spawn LM_fnc_simul };
}];

// Préparation effet visuel
_pp = ppEffectCreate ["ColorCorrections",6000];
_pp ppEffectEnable true;
_unit setVariable ["LM_narcose", _pp];

// Action unique on/off système
_statementOnOff = {
	player setVariable ["LM_system_on", !(player getVariable "LM_system_on")];
};
_modifier = {
	params ["_target", "_player", "_params", "_actionData"];
	_txt = if (player getVariable "LM_system_on") then { "Switch OFF" } else { "Switch ON" };
	_actionData set [1, _txt];
};
_actionOnOff = ["SwitchRebreatherOnOff", "Switch ON", "", _statementOnOff, {true}, {}, [], "", 1, [false, false, false, false, false], _modifier] call ace_interact_menu_fnc_createAction;
[(typeOf _unit), 1, ["ACE_SelfActions"], _actionOnOff] call ace_interact_menu_fnc_addActionToClass;

// Affichage temporaire stats
_conditionShow = {
	_retour = false;
	if!(goggles player isEqualTo "G_B_Diving") then {_retour = true};
	_retour
};
_actionShow = ["ShowStats","Check stats","",{[player, 5] spawn LM_fnc_display},_conditionShow] call ace_interact_menu_fnc_createAction;
[(typeOf _unit), 1, ["ACE_SelfActions"], _actionShow] call ace_interact_menu_fnc_addActionToClass;

// Affichage permanent stats ==> Ne marche qu'une fois, à améliorer TODO
[_unit, -1] spawn LM_fnc_display;

// Switch ON goggles TEMP TODO
_actionGoggles = ["ShowG","Show stats","",{[player, -1] spawn LM_fnc_display},{true}] call ace_interact_menu_fnc_createAction;
[(typeOf _unit), 1, ["ACE_SelfActions"], _actionGoggles] call ace_interact_menu_fnc_addActionToClass;