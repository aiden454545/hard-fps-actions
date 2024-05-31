extends Node

var mouse_move: Vector3
var sway_trheshold = 5
var sway_lerp = 5

@export var marker: Marker3D


@export var sway_up: Vector3
@export var sway_down: Vector3
@export var sway_left: Vector3
@export var sway_right: Vector3
@export var sway_normal: Vector3

func _ready():
	pass


func _input(event):
	if event is InputEventMouseMotion:
		mouse_move.y = -event.relative.y
		mouse_move.x = -event.relative.x


func _process(delta):
	if mouse_move != null:
		if mouse_move.y > sway_trheshold:
			marker.rotation = marker.rotation.lerp(sway_up, sway_lerp * delta)
		elif mouse_move.y < - sway_trheshold:
			marker.rotation = marker.rotation.lerp(sway_down, sway_lerp * delta)
		else:
			marker.rotation = marker.rotation.lerp(sway_normal, sway_lerp * delta)
		if mouse_move.x > sway_trheshold:
			marker.rotation = marker.rotation.lerp(sway_left, sway_lerp * delta)
		elif mouse_move.x < - sway_trheshold:
			marker.rotation = marker.rotation.lerp(sway_right, sway_lerp * delta)
		else:
			marker.rotation = marker.rotation.lerp(sway_normal, sway_lerp * delta)
	else:
		marker.rotation = marker.rotation.lerp(sway_normal, sway_lerp * delta)
