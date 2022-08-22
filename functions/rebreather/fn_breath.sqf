// Modélise l'inspiration du joueur dans le "bag" en retirant une quantité d'oxygène du sac dépendant de la profondeur
// Niveau nominal : 0.5
params["_unit"];

_sac = _unit getVariable "LM_breath_bag"; //niveau d'air dans le sac
_inspi = [_unit] call LM_fnc_getRate; //ce qui doit être retiré

//On retire du sac
_sac = _sac - _inspi;
if (_sac < 0) then { _sac = 0 };

//Si le joueur nage à la surface, on estime qu'il respire hors du masque
if(eyePos _unit select 2 > 0) exitWith {};
//en revanche, le sac conserve son éventuel déficit d'oxygène

// On met à jour le niveau du sac.
_unit setVariable ["LM_breath_bag", _sac];