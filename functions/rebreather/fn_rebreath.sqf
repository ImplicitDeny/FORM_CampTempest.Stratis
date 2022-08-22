// Modélise le remplissage du sac par la bouteille pour compenser l'inspiration
params["_unit"];

if!(_unit getVariable "LM_system_on") exitWith {};

// Récupération de l'air dans la bouteille item
_airItem = 0;
_item = (magazinesAmmoCargo vestContainer _unit) select 0;
if( !(isNil{_item}) && {_item select 0 isEqualTo "GSRI_OxygeneBottle"} ) then {
	_airItem = _item select 1;
};

_sac = _unit getVariable "LM_breath_bag"; // air dans le sac
_bouteille = _unit getVariable "LM_breath_lvl"; // air dans la bouteille virtuelle
//pallier que le rebreather doit maintenir, utilisation d'une variable permettra de simuler un dysfonctionnement.
_optimal = _unit getVariable "LM_breath_opti";

// Si il y a plus d'air dans la variable que dans la bouteille, c'est que la bouteille a changé.
// Si il y a plus d'une unité d'air de plus dans la bouteille que dans la variable, c'est que la bouteille a changé
// Dans les deux cas, on actualise
if( _bouteille > _airItem || {_airItem - _bouteille > 1} ) then {
	_bouteille = _airItem;
};

// Compensation de l'oxygène par la bouteille
_deficit = _optimal - _sac;
if( _bouteille >= _deficit ) then {
	_sac = _optimal; // Si la bouteille contient le nécessaire, remise au stade optimal
	_bouteille = _bouteille - _deficit; //et vidage de la bouteille d'autant
} else {
	// Si la bouteille ne suffit plus
	_sac = _sac + _bouteille; //on vide ce qu'il reste de la bouteille dans le sac
	_bouteille = 0; //et on passe la bouteille à zéro
};

// Mise à jour des niveaux
_unit setVariable ["LM_breath_bag", _sac];
_unit setVariable ["LM_breath_lvl", _bouteille];

// Mise à jour de la bouteille virtuelle, à l'unité près
// +1 pour éviter qu'une bouteille à 0 disparaisse de l'inventaire (donc >= 2)
if(_airItem - _bouteille >= 2) then {
	_unit removeItemFromVest "GSRI_OxygeneBottle";
	(vestContainer _unit) addMagazineAmmoCargo ["GSRI_OxygeneBottle", 1, _bouteille+1];
};