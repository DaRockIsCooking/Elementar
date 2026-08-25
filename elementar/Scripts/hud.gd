extends CanvasLayer

@export var player: Player

@onready var health: Label = $Top/Health
@onready var mana: Label = $Top/Mana


func _ready() -> void:
	if player == null:
		return

	player.health_changed.connect(update_health)
	player.mana_changed.connect(update_mana)

	update_health(player.health)
	update_mana(player.mana)


func update_health(value: int) -> void:
	health.text = "Health: " + str(value)


func update_mana(value: int) -> void:
	mana.text = "Mana: " + str(value)
