extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var coin_counter = 0

var can_control: bool = true # Controla entrada do jogador
var can_move: bool = true   # Controla se o CharacterBody2D pode se mover e animar (usado na cutscene)

@onready var animation := $anim as AnimatedSprite2D
@onready var coin_label = $Camera2D2/Label # Verifique este NodePath, parece que a Label está dentro da Camera2D2
var is_jumping := false

func _physics_process(delta: float) -> void:
	# A lógica de controle e movimento só roda se can_control e can_move forem true
	if not can_control or not can_move:
		# Se não pode mover/controlar, zera velocidade e anima idle (ou a animação de sono)
		velocity.x = 0
		velocity.y = 0
		if not can_move: # Se can_move for false (para cutscene), talvez já esteja animando sleep
			# Não chame play("idle") aqui se a animação de sleep já estiver tocando
			# Deixe o play_animation controlar isso
			pass
		else: # Se can_control é false (morto, etc), mas can_move é true, ele fica idle
			animation.play("idle") # Garante que ele não está preso em outra anim
		
		move_and_slide() # Ainda precisa para gravidade/colisão, mesmo parado
		return # Sai da função cedo

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
		animation.scale.x = direction
		if not is_jumping:
			animation.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle")

	if is_jumping:
		animation.play("jump")

	move_and_slide()

# --- Função Adicionada para a Cutscene ---
func play_animation(anim_name: String) -> void:
	# Esta função será chamada pelo CochiloTrigger para mudar a animação
	animation.play(anim_name)

# --- Suas funções existentes (inalteradas ou com pequenos ajustes) ---
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("coin"):
		set_coin(coin_counter + 1)
		print(coin_counter)

func set_coin(new_coin_count: int) -> void:
	coin_counter = new_coin_count
	if is_instance_valid(coin_label): # Adicionado para evitar erro se label não existe
		coin_label.text = "Score: " + str(coin_counter )

func handle_danger() -> void:
	print("Gato morreu!")
	visible = false
	can_control = false # Usando can_control para morte
	can_move = false # Também desabilita movimento ao morrer
	
	await get_tree().create_timer(0.5).timeout
	reset_player()
	
var reset_position: Vector2 = Vector2.ZERO # Use esta propriedade se for para salvar o spawn point

func reset_player() -> void:
	print("Gato/Rato resetado!")
	visible = true
	can_control = true
	can_move = true # Habilita movimento de volta
	global_position = reset_position
	velocity = Vector2.ZERO


func _on_door_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
