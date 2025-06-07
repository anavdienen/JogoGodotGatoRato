extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -200.0

@export var cat_node: NodePath
@onready var animation := $anim as AnimatedSprite2D

var is_mounted := false
var is_jumping := false
var cat
var can_control: bool = true
var can_move = true

func _ready():
	cat = get_node(cat_node)
	
func _physics_process(delta):
	if is_mounted and cat:
		velocity = Vector2.ZERO
		global_position = cat.global_position + Vector2(10, -10)
	elif not can_control : return
	
	if can_move:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("p2_jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			is_jumping = true
		elif is_on_floor():
			is_jumping = false

		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("p2_move_left", "p2_move_right")

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

	else:
		# Se não pode mover, zera velocidade e anima idle
		velocity.x = 0
		velocity.y = 0
		animation.play("idle")

	# Alternar montagem
	if Input.is_action_just_pressed("p2_mount"):
		if is_mounted:
			is_mounted = false
		elif position.distance_to(cat.position) < 50:
			is_mounted = true	
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.


	move_and_slide()
	
func handle_danger() -> void:
	print("Rato morreu!")
	visible = false
	can_control = false
	
	await get_tree().create_timer(0.5).timeout
	reset_player()
	
var reset_position: Vector2 = Vector2.ZERO 

func reset_player() -> void:
	print("Gato/Rato resetado!")
	visible = true
	can_control = true
	global_position = reset_position
	velocity = Vector2.ZERO
