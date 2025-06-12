extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -200.0

@export var cat_node: NodePath # Caminho para o nó do Gato
@onready var animation := $anim as AnimatedSprite2D # Seu AnimatedSprite2D

var is_mounted := false
var is_jumping := false
var cat 
var can_control: bool = true 
var can_move: bool = true   

func _ready():
	cat = get_node(cat_node)
	
func _physics_process(delta):

	if is_mounted and is_instance_valid(cat):
		velocity = Vector2.ZERO 
		global_position = cat.global_position + Vector2(10, -10)

		animation.play("idle") 
		

		if can_control and Input.is_action_just_pressed("p2_mount"):
			is_mounted = false # Desmonta se já estiver montado
		
		return 


	if not can_control or not can_move:
		velocity.x = 0
		velocity.y = 0

		if not can_move: 
			pass
		else: 
			animation.play("idle") 
		
		move_and_slide() 
		return 

	if not is_on_floor():
		velocity += get_gravity() * delta

	if can_control and Input.is_action_just_pressed("p2_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	elif is_on_floor():
		is_jumping = false


	var direction := 0.0
	if can_control: 
		direction = Input.get_axis("p2_move_left", "p2_move_right")

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

	
	if can_control and Input.is_action_just_pressed("p2_mount"):
		if is_instance_valid(cat) and position.distance_to(cat.position) < 50:
			is_mounted = true	
		
	move_and_slide()
	
func play_animation(anim_name: String) -> void:
	animation.play(anim_name)
	
func handle_danger() -> void:
	print("Rato morreu!")
	visible = false
	can_control = false
	can_move = false # Também desabilita movimento ao morrer
	
	await get_tree().create_timer(0.5).timeout
	reset_player()
	
var reset_position: Vector2 = Vector2.ZERO # Use esta propriedade se for para salvar o spawn point

func reset_player() -> void:
	print("Gato/Rato resetado!")
	visible = true
	can_control = true # Retorna o controle
	can_move = true # Retorna a capacidade de mover
	global_position = reset_position
	velocity = Vector2.ZERO
	
	
