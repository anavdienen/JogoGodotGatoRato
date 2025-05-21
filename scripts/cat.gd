extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -250.0

@onready var animation := $anim as AnimatedSprite2D
var is_jumping := false
var can_move = true  # deve iniciar como true

func _physics_process(delta: float) -> void:
	if can_move:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
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

	else:
		# Se não pode mover, zera velocidade e anima idle
		velocity.x = 0
		velocity.y = 0
		animation.play("idle")

	move_and_slide()
