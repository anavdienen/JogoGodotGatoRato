extends Camera2D

var target: Node2D

func _ready() -> void:
	get_target()

func _process(delta: float) -> void:
	position = target.position

func get_target() -> void:
	var nodes = get_tree().get_nodes_in_group("Player")
	if nodes.size() == 0:
		push_error("Player not found")
		return
	
	target = nodes[0]


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
