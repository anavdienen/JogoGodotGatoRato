extends Area2D

@export var nextScene := ""
var is_door_opened := false # Nova variável para controlar o estado da porta

func _physics_process(delta: float) -> void:
	# Só verifica por colisões se a porta estiver aberta
	if is_door_opened: 
		var bodies = get_overlapping_bodies()
		for body in bodies:
			# Certifique-se de que esses são os nomes dos corpos que você quer que passem pela porta
			if body.name == "Cat" || body.name == "Rat" || body.name == "Rat1": 
				pass
				get_tree().change_scene_to_file(nextScene)
			
func _on_lever_is_active() -> void:
	$AnimationPlayer.play("opening")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("opened")
	is_door_opened = true # Define que a porta está aberta após a animação


func _on_lever_2_is_active() -> void:
	pass # Replace with function body.
