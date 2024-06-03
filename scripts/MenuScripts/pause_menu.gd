extends Control

@onready var mouse_sens_slider = $MouseSensSlider
@onready var player = $".."
@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	label.text = "mouseSens: " + str(player.mouse_sens)


func mouse_sens_slider_value_changed(value):
	player.mouse_sens = mouse_sens_slider.value
