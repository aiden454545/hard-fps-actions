extends Label

var fps
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fps = Engine.get_frames_per_second()
	self.text = "FPS: " + str(fps)
