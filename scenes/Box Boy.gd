extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var speed = $AnimationPlayer.get_speed_scale()
	$AnimationPlayer.set_speed_scale(speed/1.2)
	$AnimationPlayer.play("box_boy_walk")

