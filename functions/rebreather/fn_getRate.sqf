// Récupère la consommation par seconde en fonction de la profondeur de l'unité
// Conversion linéaire impossible car courbe non-linéaire
params["_unit"];

_prof = (eyePos _unit) select 2;
_indice = switch (true) do {
	case (_prof < -40): { 9 };
	case (_prof < -35): { 8 };
	case (_prof < -30): { 7 };
	case (_prof < -25): { 6 };
	case (_prof < -20): { 5 };
	case (_prof < -15): { 4 };
	case (_prof < -12): { 3 };
	case (_prof < -10): { 2 };
	case (_prof < -9): { 1 };
	default { 0 };
};

[0.002, 0.005, 0.013, 0.022, 0.042, 0.083, 0.165, 0.195, 0.333, 0.45] select _indice