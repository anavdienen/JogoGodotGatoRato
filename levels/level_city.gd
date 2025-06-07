extends Area2D

@export var hud_path: NodePath = NodePath("../HUD")  # Caminho até o HUD

const DIALOG_SCREEN: PackedScene = preload("res://dialog/dialog_screen.tscn")

var dialog_data: Dictionary = {
	0: {
		"faceset": "res://dialog/imagens/cat.png",
		"dialog": "Droga, começou a chover",
		"title": "Gato"
	},
	1: {
		"faceset": "res://dialog/imagens/cat.png",
		"dialog": "Preciso achar um lugar seguro para dormir.",
		"title": "Gato"
	}
}

var dialog_played := false

func _on_DialogArea_body_entered(body):
	if body.name == "cat" and not dialog_played:
		var hud = get_node(hud_path)
		var dialog_instance = DIALOG_SCREEN.instantiate()
		dialog_instance.data = dialog_data
		hud.add_child(dialog_instance)
		dialog_played = true
