extends Area2D

@export var nextScene := ""

var bodies_in_area := []

func _on_body_entered(body):
	if body.name in ["Cat", "Rat", "Rat1"] and body not in bodies_in_area:
		bodies_in_area.append(body)

	var has_cat := false
	var has_rat := false

	for b in bodies_in_area:
		if b.name == "Cat":
			has_cat = true
		elif b.name == "Rat" or b.name == "Rat1":
			has_rat = true

	if has_cat and has_rat:
		get_tree().change_scene_to_file(nextScene)
