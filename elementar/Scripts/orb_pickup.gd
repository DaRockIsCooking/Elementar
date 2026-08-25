extends Area2D

@export var orb: OrbData


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.inventory.add_orb(orb)
		queue_free()
