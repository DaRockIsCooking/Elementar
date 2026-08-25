class_name Health
extends Node

@export var max_health := 10
@export var speed := 100.0
@export var damage := 1

var health: int

func _ready():
	health = max_health

func take_damage(amount: int):
	health -= amount
	
	if health <= 0:
		die()

func die():
	queue_free()
