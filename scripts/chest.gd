extends Node3D

@export var targetInputs = ""
@export var stringLength : int
@onready var needed_inputs = Labels.get_node("neededInputs")
@onready var current_inputs = Labels.get_node("currentInputs")

var keyboard_input = ""
var is_open = false
var is_interacting = false

func open():
	if is_open == false:
		$AnimationPlayer.play("chest_open")
		$Chest.queue_free()
		print("chest open")
		is_interacting = false
		needed_inputs.text = ""
		current_inputs.text = ""
		needed_inputs.visible = false
		current_inputs.visible = false
		is_open = true


func _input(event):
	if event is InputEventKey and event.is_pressed() and is_interacting == true:
		needed_inputs.text = "Needed Inputs: " + str(targetInputs)
		keyboard_input.erase(0,1)
		keyboard_input += event.as_text()
		print(keyboard_input)
		current_inputs.text = "Current Inputs: " + str(keyboard_input)
		if keyboard_input == targetInputs and keyboard_input.length() <= stringLength:
			open()
			keyboard_input = ""
		elif keyboard_input.length() > stringLength or keyboard_input.contains("R"):
			keyboard_input = ""

func _on_chest_interacted(body):
	if is_open == false:
		is_interacting = true

