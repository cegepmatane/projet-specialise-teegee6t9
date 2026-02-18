extends CanvasLayer

# Script pour afficher une carte minimap du vaisseau spatial
# Appuyez sur 'M' pour afficher/masquer la carte

@onready var panel_carte = $PanelCarte
@onready var label_carte = $PanelCarte/LabelCarte

var carte_visible = false

func _ready():
	panel_carte.visible = false

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_M:  # Touche M pour afficher la carte
			carte_visible = !carte_visible
			panel_carte.visible = carte_visible
			if carte_visible:
				afficher_carte()

func afficher_carte():
	var texte_carte = """
╔═══════════════════════════════════════════╗
║        CARTE DU VAISSEAU                  ║
╠═══════════════════════════════════════════╣
║                                           ║
║      [Nord-1]  [Nord-2]                  ║
║           │        │                      ║
║           └───[Couloir Nord]───┐          ║
║                               │          ║
║    [Ouest-1]─[Couloir Ouest]─┼─[Salle   ║
║    [Ouest-2]                  │  Centrale]║
║                               │          ║
║           └───[Couloir Sud]───┘          ║
║           │        │                      ║
║      [Sud-1]  [Sud-2]                    ║
║                                           ║
║    [Est-1]─[Couloir Est]─[Est-2]         ║
║                                           ║
║  Légende:                                 ║
║  ═══  Couloir                            ║
║  [ ]  Salle                              ║
║  🚪  Emplacement porte automatique      ║
║                                           ║
║  Pièces (8 au total):                     ║
║  • Salle Centrale (hub principal)        ║
║  • Aile Nord: 2 salles                  ║
║  • Aile Sud: 2 salles                    ║
║  • Aile Est: 2 salles                    ║
║  • Aile Ouest: 2 salles                  ║
║                                           ║
╚═══════════════════════════════════════════╝
	"""
	label_carte.text = texte_carte
