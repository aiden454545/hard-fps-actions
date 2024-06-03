extends Node

@export var ads_point: Marker3D
var player_ads_point: Marker3D
@export var handle_point: Marker3D
var player_handle_point: Marker3D
@export var weapon: RigidBody3D
@export var ads_offset: Vector3
@export var handle_offset: Vector3

@export var translate_offset: Vector3

@export var debug: bool

@export var snap: float
@export var speed: float

var old_pos
var equipped = false
var fired



var player

var target_rot
var old_rot
var target_pos
var current_point
var offset = Vector3.ZERO


func _ready():
	pass


func _process(delta):
	if !player: return
	if !player.is_multiplayer_authority(): return
	if player and equipped:
		ads_point.top_level = true
		handle_point.top_level = true
		
		player_handle_point = player.get_node("head/pivot/Camera3D/HandlePoint")
		player_ads_point = player.get_node("head/pivot/Camera3D/adsPoint")
		
		if Input.is_action_pressed("alt fire"):
			current_point = ads_point
			target_rot = player_ads_point.global_rotation
			old_rot = ads_point.global_rotation
			old_pos = ads_point.global_transform.origin
			target_pos = player_ads_point.global_transform.origin
			offset = ads_offset
#		elif fired:
#			old_pos = Vector3.ZERO
#			target_pos = Vector3.ZERO
		else:
			current_point = handle_point
			target_rot = player_handle_point.global_rotation
			old_rot = handle_point.global_rotation
			
			old_pos = handle_point.global_transform.origin
			target_pos = player_handle_point.global_transform.origin
			offset = Vector3.ZERO
		old_rot = target_rot
		old_pos = target_pos
		
		if current_point == ads_point:
			weapon.global_transform.origin = old_pos
			weapon.translate(Vector3(translate_offset))
			weapon.global_rotation = old_rot
		elif current_point == handle_point:
			weapon.global_transform.origin = old_pos + offset
			weapon.global_rotation = old_rot
		
		
		if debug:
			DebugDraw3D.draw_sphere(old_pos, 0.1, Color.GREEN)
			DebugDraw3D.draw_sphere(target_pos, 0.1, Color.RED)
		
	else:
		ads_point.top_level = false
		handle_point.top_level = false



func _on_interacted(body):
	player = body


func _on_weapon_equipped():
	equipped = true


func _on_weapon_unequipped():
	equipped = false


func _on_fired():
	fired = true



