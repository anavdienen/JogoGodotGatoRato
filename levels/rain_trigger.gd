extends Area2D

@export var rain_particles: NodePath
@export var player: NodePath
@export var thought_label: NodePath

var rain
var player_node
var label_node

var is_paused = false  # flag para controlar se já pausou

func _ready():
	rain = get_node(rain_particles)
	player_node = get_node(player)
	label_node = get_node(thought_label)

func _on_body_entered(body):
	if body == player_node and not is_paused:
		is_paused = true  # trava pra não repetir
		rain.emitting = true
		player_node.can_move = false
		label_node.text = "Droga... começou a chover... Preciso achar um lugar seguro!"
		show_thought()

func _on_body_exited(body):
	if body == player_node:
		rain.emitting = false
		# Se quiser que pare a pausa quando sair, descomente a linha abaixo
		# is_paused = false

func show_thought():
	await get_tree().create_timer(5.0).timeout
	label_node.text = ""
	player_node.can_move = true
