class_name Health_System
extends Node

@export var health: int
@export var max_health: int
@export var node_to_kill: Node3D

func _ready():
	pass # Replace with function body.



func _process(delta):
	if !owner.is_multiplayer_authority(): return
	if health > max_health:
		health = max_health
	if health <= 0:
		node_to_kill.queue_free()
