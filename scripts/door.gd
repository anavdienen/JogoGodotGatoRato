extends Area2D

@export var nextScene := ""
var is_door_opened := false
var scene_change_initiated := false 

func _physics_process(delta: float) -> void:

	if is_door_opened and not scene_change_initiated:
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body.name == "Cat" or body.name == "Rat" or body.name == "Rat1":
				scene_change_initiated = true
				
				get_tree().change_scene_to_file(nextScene)
				
				break 


func _on_lever_is_active() -> void:
	$AnimationPlayer.play("opening")
	await $AnimationPlayer.animation_finished 
	$AnimationPlayer.play("opened")
	is_door_opened = true


func _on_lever_2_is_active() -> void:
	pass
