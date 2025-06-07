extends Area2D


func _on_body_entered(body):
	if body.name == "Cat" || body.name == "Rat" || body.name == "Rat1":
		body.handle_danger()
