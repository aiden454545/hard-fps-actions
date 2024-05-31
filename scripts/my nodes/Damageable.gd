class_name Damageable
extends StaticBody3D

@export var health_node: Health_System

func _ready():
	pass



func _process(delta):
	pass

func take_damage(damage: int):
	health_node.health -= damage
	print(str(health_node.health))
