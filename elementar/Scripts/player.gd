class_name Player
extends CharacterBody2D

signal health_changed(new_health: int)
signal mana_changed(new_mana: int)

var health := 100
var mana := 100
var facing_direction := 1
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var cast_distance := 25.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var inventory: PlayerInventory = $Inventory
@onready var spell_resolver: SpellResolver = $SpellResolver
@onready var cast_point: Marker2D = $CastPoint


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("CastSpell"):
		cast_spell()

	if Input.is_action_just_pressed("TestSpell"):
		var spell: SpellData = spell_resolver.get_spell(
			inventory.equipped_orb_1,
			inventory.equipped_orb_2
		)

		if spell != null:
			print("Spell: ", spell.spell_name)
			print("Damage: ", spell.damage)
			print("Mana: ", spell.mana_cost)
			print("Cooldown: ", spell.cooldown)
		else:
			print("Keine gültige Kombination")

	if Input.is_action_just_pressed("EquipOrb1"):
		if inventory.orbs.size() >= 1:
			inventory.equip_orb(1, inventory.orbs[0])

	if Input.is_action_just_pressed("EquipOrb2"):
		if inventory.orbs.size() >= 2:
			inventory.equip_orb(2, inventory.orbs[1])

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("MoveLeft", "MoveRight")

	if direction:
		velocity.x = direction * SPEED
		facing_direction = int(sign(direction))
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not is_on_floor():
		animated_sprite.play("Jump")
	elif direction:
		animated_sprite.play("Run")
	else:
		animated_sprite.play("Idle")

	move_and_slide()


func cast_spell() -> void:
	var spell: SpellData = spell_resolver.get_spell(
		inventory.equipped_orb_1,
		inventory.equipped_orb_2
	)

	if spell == null:
		print("Kein Spell ausgerüstet")
		return

	if spell.attack_scene == null:
		print("Spell hat keine Attack Scene: ", spell.spell_name)
		return

	var attack = spell.attack_scene.instantiate()

	get_tree().current_scene.add_child(attack)

	var mouse_position := get_global_mouse_position()
	var cast_direction := global_position.direction_to(mouse_position)

	cast_point.position = cast_direction * cast_distance

	attack.global_position = cast_point.global_position

	if attack.has_method("setup"):
		attack.setup(cast_direction, spell.damage)


func take_damage(damage) -> void:
	health = health - damage
	health_changed.emit(health)
