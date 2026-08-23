extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const DASH_SPEED = 900.0
const DASH_DURATION = 0.15

var jumps_left = 2
var dashes_left = 1

var dash_time = 0.0
var dash_direction = 1.0

func _physics_process(delta: float) -> void:

	if is_on_floor():
		jumps_left = 2
		dashes_left = 1

	var direction := Input.get_axis("MoveLeft", "MoveRight")

	if direction != 0:
		dash_direction = direction

	if Input.is_action_just_pressed("Dash") and dashes_left > 0:
		dash_time = DASH_DURATION
		dashes_left -= 1

	if dash_time > 0:
		dash_time -= delta
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0

	else:
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("ui_accept") and jumps_left > 0:
			velocity.y = JUMP_VELOCITY
			jumps_left -= 1

		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
