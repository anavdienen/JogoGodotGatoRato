extends Area2D

@onready var animation_player = $AnimationPlayer

var score = 0
func _on_body_entered(body: Node2D) -> void:
	animation_player.play("pickup")
