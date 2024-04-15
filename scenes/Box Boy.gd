extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("box_boy_walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
