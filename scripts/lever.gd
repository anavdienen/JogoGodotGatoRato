extends Area2D

signal is_Active

func _physics_process(delta: float) -> void:
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Cat":
			$AnimationPlayer.play("active")
			await $AnimationPlayer.animation_finished
			$AnimationPlayer.play("active idle")
			emit_signal("is_Active")
		else:
			$AnimationPlayer.play("idle")
		
