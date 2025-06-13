extends Area2D

@export var player: NodePath # Caminho para o nó do Gato (Player principal)
@export var hud_path: NodePath # Caminho para o nó HUD
@export var rat_node_path: NodePath # Caminho para o nó do Rato

const DIALOG_SCREEN: PackedScene = preload("res://dialog/dialog_screen.tscn")

var dialog_data := { # Seus dados de diálogo já estão corretos aqui
	0: {
		"faceset": "res://dialog/imagens/cat.png",
		"dialog": "Ufa, enfim salvos!\n\n(enter)",
		"title": "Gato"
	},
	1: {
		"faceset": "res://dialog/imagens/rat.png",
		"dialog": "Pensei que não íamos escapar dessa...\n(enter)",
		"title": "Rato"
	},
	2: {
		"faceset": "res://dialog/imagens/cat.png",
		"dialog": "Eu também... Olha, até parou de chover!\n(enter)",
		"title": "Gato"
	},
	3: {
		"faceset": "res://dialog/imagens/rat.png",
		"dialog": "Finalmente! Foi bom te conhecer! Nos vemos por aí?\n(enter)",
		"title": "Rato"
	},
	4: {
		"faceset": "res://dialog/imagens/cat.png",
		"dialog": "Sempre que chover nos encontraremos! *risos*\n(enter)",
		"title": "Gato"
	},
	5: {
		"faceset": "res://dialog/imagens/rat.png",
		"dialog": "*risos* Até logo!\n(enter)",
		"title": "Rato"
	}
}

var player_node: CharacterBody2D
var rat_node: CharacterBody2D 
var dialog_played := false

func _ready():

	player_node = get_node(player)
	rat_node = get_node(rat_node_path)
	
func _on_body_entered(body: Node2D) -> void:

	if body == player_node: 
		if not dialog_played:
			var hud = get_node(hud_path)
			if not is_instance_valid(hud):
				push_error("HUD node not found at path: ", hud_path)
				return

			var dialog_instance = DIALOG_SCREEN.instantiate()
			dialog_instance.data = dialog_data

			# Conecta o sinal do diálogo que você já tem
			dialog_instance.dialog_finished.connect(_on_dialog_finished)

			hud.add_child(dialog_instance)
			dialog_played = true
			
			# Desabilita o movimento do Gato e do Rato
			if is_instance_valid(player_node):
				player_node.can_move = false
				# Para o rato também parar:
				if is_instance_valid(rat_node):
					rat_node.can_move = false
			else:
				print("AVISO: player_node não inicializado corretamente ou inválido na Area2D!")

# Função chamada quando o diálogo termina
func _on_dialog_finished():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	
