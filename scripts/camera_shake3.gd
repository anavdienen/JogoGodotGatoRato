extends Camera2D

@export var target_group_name := "Player" 

var target: Node2D

# Variáveis para o tremor de tela (com duração e decaimento)
var shake_duration := 0.0      # Duração total do tremor (para cada "tremida" individual)
var shake_intensity := 0.0     # Intensidade do tremor (magnitude do deslocamento)
var shake_decay := 0.0         # Taxa de decaimento do tremor

var current_shake_time := 0.0  # Tempo restante do tremor
var original_offset := Vector2.ZERO # Guarda o offset original da câmera

func _ready() -> void:
	get_target()
	original_offset = offset 

func _process(delta: float) -> void:
	if target:
		position = target.position

	if current_shake_time > 0:
		var x_shake = randf_range(-3.0, 3.0) * shake_intensity
		var y_shake = randf_range(-3.0, 3.0) * shake_intensity

		offset = original_offset + Vector2(x_shake, y_shake)

		shake_intensity = lerp(shake_intensity, 0.0, shake_decay * delta) 
		current_shake_time -= delta
	else:
		if offset != original_offset:
			offset = original_offset
		if shake_intensity != 0.0:
			shake_intensity = 0.0

func get_target() -> void:
	var nodes = get_tree().get_nodes_in_group(target_group_name)
	if nodes.size() == 0:
		push_error("Player not found in group: " + target_group_name)
		return
	
	target = nodes[0]

func start_shake(duration: float, intensity: float, decay: float = 5.0):
	shake_duration = duration
	shake_intensity = intensity
	shake_decay = decay
	current_shake_time = duration
