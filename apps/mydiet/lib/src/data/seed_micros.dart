/// Vitamins and minerals of the reference foods per 100 g (or 100 ml), in the catalogue unit
/// of core/supplements.dart (µg or mg). Rounded averages of the German food table (BLS) and
/// USDA FoodData Central for unfortified products. Values vary by product, season and
/// preparation; the app shows them as "Richtwerte". A missing nutrient means "unknown".
///
/// Keys must match [referenceFoods] names (checked by a test).
library;

/// Short helper so the table stays readable: d = vit_d, b12, fol = folate, c = vit_c,
/// ca, mg, fe, zn, k = potassium, j = iodine, o3 = omega3 (EPA + DHA).
Map<String, double> _m({
  double? d,
  double? b12,
  double? fol,
  double? c,
  double? ca,
  double? mg,
  double? fe,
  double? zn,
  double? k,
  double? j,
  double? o3,
}) => {
  'vit_d': ?d,
  'vit_b12': ?b12,
  'folate': ?fol,
  'vit_c': ?c,
  'calcium': ?ca,
  'magnesium': ?mg,
  'iron': ?fe,
  'zinc': ?zn,
  'potassium': ?k,
  'iodine': ?j,
  'omega3': ?o3,
};

final Map<String, Map<String, double>> referenceMicros = {
  // Fleisch, Fisch, Wurst
  'Hähnchenbrustfilet, roh': _m(b12: 0.3, ca: 5, mg: 28, fe: 0.4, zn: 0.7, k: 330),
  'Hähnchenbrust, gebraten': _m(b12: 0.3, ca: 6, mg: 30, fe: 0.5, zn: 1.0, k: 340),
  'Putenbrust, roh': _m(b12: 0.5, ca: 6, mg: 28, fe: 0.6, zn: 1.2, k: 330),
  'Rinderhackfleisch (20 % Fett), roh': _m(b12: 2.0, ca: 15, mg: 17, fe: 2.0, zn: 4.2, k: 270),
  'Rinderhackfleisch mager (5 % Fett), roh': _m(b12: 2.2, ca: 10, mg: 21, fe: 2.3, zn: 5.0, k: 330),
  'Rinderhüftsteak, roh': _m(b12: 1.6, ca: 8, mg: 23, fe: 2.0, zn: 4.0, k: 340),
  'Schweinefilet, roh': _m(b12: 0.6, ca: 6, mg: 27, fe: 1.0, zn: 1.9, k: 400),
  'Kochschinken': _m(b12: 0.5, ca: 8, mg: 20, fe: 0.9, zn: 2.0, k: 290),
  'Salami': _m(b12: 1.5, ca: 10, mg: 20, fe: 1.5, zn: 3.0, k: 340),
  'Bratwurst (Schwein)': _m(b12: 1.0, ca: 15, mg: 15, fe: 1.0, zn: 2.0, k: 250),
  'Lachs, roh': _m(d: 8, b12: 3.2, ca: 10, mg: 29, fe: 0.4, zn: 0.4, k: 360, j: 30, o3: 2000),
  'Räucherlachs': _m(d: 7, b12: 3.0, ca: 11, mg: 18, fe: 0.9, zn: 0.3, k: 175, o3: 1500),
  'Kabeljau, roh': _m(d: 1, b12: 0.9, ca: 16, mg: 32, fe: 0.4, zn: 0.5, k: 410, j: 120, o3: 200),
  'Thunfisch im eigenen Saft, abgetropft': _m(d: 1.5, b12: 2.5, ca: 11, mg: 27, fe: 1.5, zn: 0.8, k: 240, o3: 250),
  'Garnelen, roh': _m(b12: 1.1, ca: 55, mg: 22, fe: 0.2, zn: 1.0, k: 110, o3: 150),

  // Eier, Milchprodukte
  'Hühnerei': _m(d: 2.0, b12: 1.0, fol: 47, ca: 56, mg: 12, fe: 1.8, zn: 1.3, k: 140, j: 10),
  'Eiklar': _m(b12: 0.1, ca: 7, mg: 11, fe: 0.1, k: 160),
  'Skyr natur': _m(b12: 0.5, ca: 150, mg: 12, zn: 0.5, k: 160, j: 10),
  'Magerquark': _m(b12: 0.8, ca: 90, mg: 11, zn: 0.5, k: 160, j: 10),
  'Speisequark 40 % Fett i. Tr.': _m(b12: 0.6, ca: 85, mg: 10, zn: 0.4, k: 120),
  'Naturjoghurt 1,5 %': _m(b12: 0.4, ca: 130, mg: 12, zn: 0.5, k: 170, j: 8),
  'Griechischer Joghurt 10 %': _m(b12: 0.3, ca: 100, mg: 11, zn: 0.4, k: 140),
  'Hüttenkäse': _m(b12: 0.6, ca: 80, mg: 8, zn: 0.4, k: 100),
  'Milch 1,5 %': _m(b12: 0.4, fol: 5, ca: 120, mg: 12, zn: 0.4, k: 150, j: 10),
  'Milch 3,5 %': _m(b12: 0.4, fol: 5, ca: 120, mg: 12, zn: 0.4, k: 150, j: 10),
  'Gouda 45 % Fett i. Tr.': _m(d: 0.3, b12: 1.5, ca: 800, mg: 30, fe: 0.2, zn: 3.9, k: 120),
  'Mozzarella': _m(b12: 1.5, ca: 500, mg: 20, zn: 2.9, k: 80),
  'Feta': _m(b12: 1.7, ca: 490, mg: 19, zn: 2.9, k: 60),
  'Parmesan': _m(b12: 1.2, ca: 1180, mg: 44, fe: 0.8, zn: 2.8, k: 125),
  'Frischkäse Doppelrahmstufe': _m(b12: 0.2, ca: 100, mg: 9, zn: 0.5, k: 130),
  'Frischkäse light': _m(b12: 0.3, ca: 120, mg: 10, k: 150),
  'Butter': _m(d: 1.2, ca: 15, k: 20),
  'Schlagsahne 30 %': _m(ca: 80, mg: 8, k: 100),
  'Tofu natur': _m(fol: 15, ca: 200, mg: 30, fe: 2.7, zn: 1.0, k: 120),

  // Hülsenfrüchte
  'Rote Linsen, getrocknet': _m(fol: 200, ca: 35, mg: 60, fe: 7.5, zn: 3.6, k: 580),
  'Kichererbsen (Dose), abgetropft': _m(fol: 50, ca: 40, mg: 25, fe: 1.3, zn: 0.9, k: 120),
  'Kidneybohnen (Dose), abgetropft': _m(fol: 50, ca: 35, mg: 30, fe: 1.4, zn: 0.7, k: 260),
  'Hummus': _m(fol: 80, ca: 40, mg: 70, fe: 2.4, zn: 1.8, k: 230),

  // Getreide, Brot, Kartoffeln
  'Reis, roh': _m(fol: 8, ca: 9, mg: 25, fe: 0.8, zn: 1.1, k: 115),
  'Reis, gekocht': _m(ca: 3, mg: 12, fe: 0.2, zn: 0.5, k: 35),
  'Vollkornreis, gekocht': _m(ca: 5, mg: 40, fe: 0.5, zn: 0.6, k: 85),
  'Nudeln (Hartweizen), roh': _m(fol: 18, ca: 20, mg: 50, fe: 1.3, zn: 1.4, k: 220),
  'Nudeln, gekocht': _m(ca: 7, mg: 18, fe: 0.5, zn: 0.5, k: 45),
  'Vollkornnudeln, roh': _m(fol: 40, ca: 40, mg: 140, fe: 3.6, zn: 2.9, k: 300),
  'Couscous, roh': _m(fol: 20, ca: 24, mg: 44, fe: 1.1, zn: 0.8, k: 170),
  'Quinoa, roh': _m(fol: 180, ca: 47, mg: 197, fe: 4.6, zn: 3.1, k: 560),
  'Haferflocken': _m(fol: 30, ca: 50, mg: 130, fe: 4.0, zn: 3.6, k: 360),
  'Vollkornbrot': _m(fol: 30, ca: 40, mg: 60, fe: 2.0, zn: 1.8, k: 250),
  'Weizenbrötchen': _m(ca: 25, mg: 25, fe: 1.0, zn: 0.8, k: 120),
  'Toastbrot': _m(ca: 30, mg: 25, fe: 1.2, zn: 0.8, k: 120),
  'Knäckebrot (Roggen)': _m(ca: 30, mg: 80, fe: 2.5, zn: 2.5, k: 320),
  'Reiswaffeln': _m(ca: 10, mg: 130, fe: 1.5, zn: 2.5, k: 290),
  'Müsli ohne Zuckerzusatz': _m(ca: 50, mg: 100, fe: 3.5, zn: 2.5, k: 450),
  'Kartoffeln, roh': _m(fol: 15, c: 15, ca: 10, mg: 23, fe: 0.8, zn: 0.3, k: 420),
  'Kartoffeln, gekocht': _m(c: 10, ca: 8, mg: 20, fe: 0.4, k: 380),
  'Süßkartoffel, roh': _m(c: 2.4, ca: 30, mg: 25, fe: 0.6, k: 340),
  'Pommes frites (Backofen)': _m(c: 10, mg: 25, fe: 0.8, k: 450),
  'Pizza Margherita (TK)': _m(ca: 180, mg: 20, fe: 1.3, k: 180),

  // Gemüse
  'Brokkoli': _m(fol: 63, c: 90, ca: 47, mg: 21, fe: 0.7, k: 315),
  'Blumenkohl': _m(fol: 57, c: 48, ca: 22, mg: 15, k: 300),
  'Karotte': _m(fol: 19, c: 6, ca: 33, mg: 12, k: 320),
  'Tomate': _m(fol: 15, c: 14, mg: 11, k: 237),
  'Gurke': _m(c: 3, mg: 13, k: 147),
  'Paprika, rot': _m(fol: 46, c: 128, mg: 12, k: 211),
  'Zucchini': _m(fol: 24, c: 18, mg: 18, k: 261),
  'Spinat': _m(fol: 194, c: 28, ca: 99, mg: 79, fe: 2.7, k: 558),
  'Kopfsalat': _m(fol: 38, c: 9, ca: 36, k: 194),
  'Champignons': _m(fol: 17, mg: 9, zn: 0.5, k: 318),
  'Zwiebel': _m(fol: 19, c: 7, k: 146),
  'Grüne Bohnen': _m(fol: 33, c: 12, ca: 37, mg: 25, k: 211),
  'Erbsen (TK)': _m(fol: 60, c: 18, mg: 22, fe: 1.5, zn: 0.7, k: 150),
  'Mais (Dose), abgetropft': _m(fol: 40, c: 5, mg: 20, k: 190),
  'Rotkohl': _m(fol: 18, c: 57, ca: 45, k: 243),
  'Avocado': _m(fol: 81, c: 10, mg: 29, k: 485),

  // Obst
  'Apfel': _m(c: 5, k: 107),
  'Banane': _m(fol: 20, c: 9, mg: 27, k: 358),
  'Orange': _m(fol: 30, c: 53, ca: 40, k: 181),
  'Birne': _m(c: 4, k: 116),
  'Erdbeeren': _m(fol: 24, c: 59, k: 153),
  'Heidelbeeren': _m(c: 10, k: 77),
  'Weintrauben': _m(c: 3, k: 191),
  'Kiwi': _m(fol: 25, c: 93, k: 312),
  'Mango': _m(fol: 43, c: 36, k: 168),
  'Apfelmus ungesüßt': _m(c: 1, k: 75),
  'Rosinen': _m(mg: 32, fe: 1.9, k: 750),
  'Datteln, getrocknet': _m(mg: 50, fe: 0.9, k: 650),
  'Orangensaft': _m(fol: 30, c: 40, k: 200),

  // Nüsse, Samen
  'Mandeln': _m(fol: 44, ca: 270, mg: 270, fe: 3.7, zn: 3.1, k: 730),
  'Walnüsse': _m(fol: 98, ca: 98, mg: 158, fe: 2.9, zn: 3.1, k: 441),
  'Erdnüsse, geröstet': _m(fol: 145, ca: 55, mg: 175, fe: 2.3, zn: 3.3, k: 660),
  'Erdnussbutter': _m(fol: 90, ca: 45, mg: 170, fe: 1.9, zn: 2.9, k: 560),
  'Leinsamen': _m(ca: 255, mg: 392, fe: 5.7, zn: 4.3, k: 813),
  'Chiasamen': _m(ca: 631, mg: 335, fe: 7.7, zn: 4.6, k: 407),
  'Sonnenblumenkerne': _m(fol: 227, ca: 78, mg: 325, fe: 5.3, zn: 5.0, k: 645),
  'Kokosmilch': _m(mg: 37, fe: 1.6, k: 220),

  // Süßes, Getränke
  'Zartbitterschokolade 70 %': _m(ca: 73, mg: 228, fe: 11.9, zn: 3.3, k: 715),
  'Vollmilchschokolade': _m(ca: 189, mg: 63, fe: 2.4, zn: 2.3, k: 372),
  'Kaffee, schwarz': _m(mg: 3, k: 50),
};
