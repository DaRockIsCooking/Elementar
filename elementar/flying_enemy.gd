extends CharacterBody2D

@export var speed := 120.0
@export var damage := 1
@export var player: CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var attack_area: Area2D = $AttackArea
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

enum State {
	FLY,
	ATTACK,
	DEAD,
	IDLE
}

var state: State = State.FLY

func _ready() -> void:
	update_animation()

func _physics_process(_delta: float) -> void:
	if player == null:
		state = State.IDLE
		update_animation()
	
	if state == State.DEAD:
		velocity = Vector2.ZERO
		return
		
	# Nahkampfangriff
	if player in attack_area.get_overlapping_bodies():
		velocity = Vector2.ZERO
		attack()
		move_and_slide()
		return

	# Pathfinding Flying
	navigation_agent.target_position = player.global_position
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	var next_position = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_position)
	velocity = direction * speed
	move_and_slide()

func attack() -> void:
	if not attack_cooldown.is_stopped():
		return
	attack_cooldown.start()
	state = State.ATTACK
	update_animation()
	if player.has_method("take_damage"):
		player.take_damage(damage)
	# Warten bis Attack komplett fertig ist
	await animated_sprite.animation_finished
	state = State.FLY
	update_animation()

func update_animation() -> void:
	match state:
		State.FLY:
			animated_sprite.play("Run")
		State.ATTACK:
			animated_sprite.play("Attack")
		State.DEAD:
			animated_sprite.play("Death")
		State.IDLE:
			animated_sprite.play("Idle")

func die() -> void:
	state = State.DEAD
	update_animation()
