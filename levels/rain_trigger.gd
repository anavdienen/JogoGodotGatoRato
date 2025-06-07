# rain_trigger.gd

extends Area2D

@export var rain_particles: NodePath
@export var player: NodePath
@export var thought_label: NodePath
@export var hud_path: NodePath

const DIALOG_SCREEN: PackedScene = preload("res://dialog/dialog_screen.tscn")

var dialog_data := {
	0: {
		"faceset": "res://dialog/imagens/cat.png",
		"dialog": "Droga, começou a chover...\n\n(enter)",
		"title": "Gato"
	},
	1: {
		"faceset": "res://dialog/imagens/cat.png",
		"dialog": "Preciso achar um lugar seguro para dormir.\n(enter)",
		"title": "Gato"
	}
}

var rain
var player_node
var label_node
var dialog_played := false

func _ready():
	rain = get_node(rain_particles)
	player_node = get_node(player)
	label_node = get_node(thought_label)

func _on_body_entered(body):
	if body == player_node:
		rain.emitting = true

		if not dialog_played:
			var hud = get_node(hud_path)
			var dialog_instance = DIALOG_SCREEN.instantiate()
			dialog_instance.data = dialog_data

			# 🔗 Conecta o sinal para saber quando o diálogo termina
			dialog_instance.dialog_finished.connect(_on_dialog_finished)

			hud.add_child(dialog_instance)
			dialog_played = true
			player_node.can_move = false

func _on_body_exited(body):
	if body == player_node:
		rain.emitting = false

func _on_dialog_finished():
	player_node.can_move = true
