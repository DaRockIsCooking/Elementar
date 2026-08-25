class_name SpellResolver
extends Node

@export var fireball: SpellData
@export var steam_blast: SpellData


func get_spell(orb_1: OrbData, orb_2: OrbData) -> SpellData:
	if orb_1 == null or orb_2 == null:
		return null

	var element_1 = orb_1.element
	var element_2 = orb_2.element

	# Fire + Fire
	if element_1 == OrbData.Element.FIRE and element_2 == OrbData.Element.FIRE:
		return fireball

	# Fire + Water / Water + Fire
	if (
		(element_1 == OrbData.Element.FIRE and element_2 == OrbData.Element.WATER)
		or
		(element_1 == OrbData.Element.WATER and element_2 == OrbData.Element.FIRE)
	):
		return steam_blast

	return null
