class_name Player
extends CharacterBody2D

signal health_changed(new_health: int)
signal mana_changed(new_mana: int)

var health := 100
var mana := 100

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("MoveLeft", "MoveRight")

	if direction:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Animationen
	if not is_on_floor():
		animated_sprite.play("Jump")
	elif direction:
		animated_sprite.play("Run")
	else:
		animated_sprite.play("Idle")

	move_and_slide()

func take_damage(damage):
	health = health - damage
	health_changed.emit(health)
