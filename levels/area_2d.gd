extends Area2D

@export var player: NodePath
@export var thought_label: NodePath 
@export var hud_path: NodePath 
@export var rat_node_path: NodePath

const DIALOG_SCREEN: PackedScene = preload("res://dialog/dialog_screen.tscn")

var dialog_data := {
	0: {
		"faceset": "res://dialog/imagens/rat.png",
		"dialog": "Ei, você, gato!\n\n(enter)",
		"title": "Rato"
	},
	1: {
		"faceset": "res://dialog/imagens/cat.png",
		"dialog": "Oi... Precisa de alguma coisa?\n(enter)",
		"title": "Gato"
	},
	2: {
		"faceset": "res://dialog/imagens/rat.png",
		"dialog": "É... Na verdade, sim, preciso que me ajude a atravessar\n(enter)",
		"title": "Rato"
	},
	3: {
		"faceset": "res://dialog/imagens/rat.png",
		"dialog": "Eu não consigo sozinho, sou pequeno demais.\n(enter)",
		"title": "Rato"
	},
	4: {
		"faceset": "res://dialog/imagens/cat.png",
		"dialog": "Ok... Monta aí que eu te levo até o outro lado\n(enter)",
		"title": "Gato"
	},
}

var player_node: CharacterBody2D 
var rat_node: CharacterBody2D
var label_node
var dialog_played := false

func _ready():
	player_node = get_node(player)
	rat_node = get_node(rat_node_path)
	self.body_entered.connect(_on_Area2D_body_entered)


func _on_Area2D_body_entered(body):
	if body.name == "Cat":
		if not dialog_played:
			var hud = get_node(hud_path)
			var dialog_instance = DIALOG_SCREEN.instantiate()
			dialog_instance.data = dialog_data

			dialog_instance.dialog_finished.connect(_on_dialog_finished)

			hud.add_child(dialog_instance)
			dialog_played = true
			
			if player_node: 
				player_node.can_move = false
			else:
				print("AVISO: player_node não inicializado corretamente na Area2D!")


func _on_dialog_finished():
	
	if player_node: 
		player_node.can_move = true
	
	
	Global.segundo_personagem_desbloqueado = true
	
	if rat_node: # Garante que a referência não é nula
		rat_node.enable_control()

	print("Diálogo terminou, segundo personagem desbloqueado!")

	Global.segundo_personagem_desbloqueado = true
