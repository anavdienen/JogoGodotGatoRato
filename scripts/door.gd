extends Area2D

func _physics_process(delta: float) -> void:
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Cat":
			pass
			get_tree().change_scene_to_file("res://levels/testbed_level.tscn") # <- caso a porta leve para outra cena, so colocar o endereço dela aqui
			

func _on_lever_is_active() -> void:
	$AnimationPlayer.play("opening")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("opened")
