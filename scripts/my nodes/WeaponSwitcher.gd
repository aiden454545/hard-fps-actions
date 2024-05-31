extends Node

@export var ray_cast: RayCast3D
var detected
var slot_1
var slot_2
var slot_3
var slot_1_open = false
var slot_2_open = false
var slot_3_open = false


func _ready():
	pass



func _process(delta):
	if ray_cast.is_colliding():
		detected = ray_cast.get_collider()
		
	if detected is WeaponInteractable:
		if slot_1_open:
			slot_1 = detected
			if slot_1 is WeaponInteractable:
				slot_1_open = false
