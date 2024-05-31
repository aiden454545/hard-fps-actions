extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var speed = $AnimationPlayer.get_speed_scale()
	$AnimationPlayer.set_speed_scale(speed/1.2)
	$AnimationPlayer.play("box_boy_walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass#translate(Vector3(-0.1, 0, 0))
