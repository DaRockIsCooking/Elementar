class_name PlayerInventory
extends Node

var staffs: Array[StaffData] = []
var orbs: Array[OrbData] = []

var equipped_staff: StaffData
var equipped_orb_1: OrbData
var equipped_orb_2: OrbData


func add_staff(staff: StaffData) -> void:
	staffs.append(staff)


func add_orb(orb: OrbData) -> void:
	orbs.append(orb)
	print("Orb aufgehoben: ", orb.orb_name)

func equip_staff(staff: StaffData) -> void:
	if staff in staffs:
		equipped_staff = staff


func equip_orb(slot: int, orb: OrbData) -> void:
	if orb not in orbs:
		return

	if slot == 1:
		equipped_orb_1 = orb
		print("Orb Slot 1: ", orb.orb_name)

	elif slot == 2:
		equipped_orb_2 = orb
		print("Orb Slot 2: ", orb.orb_name)
