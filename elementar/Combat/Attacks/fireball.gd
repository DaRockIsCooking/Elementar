class_name Fireball
extends Area2D

@export var speed := 500.0

var direction := Vector2.RIGHT
var damage := 0.0


func setup(new_direction: Vector2, new_damage: float) -> void:
	direction = new_direction.normalized()
	damage = new_damage


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)

	queue_free()
