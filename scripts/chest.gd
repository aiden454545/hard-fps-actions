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
		$Chest2/CollisionShape3D.disabled = false
		print("chest open")
		is_interacting = false
		needed_inputs.text = ""
		current_inputs.text = ""
		needed_inputs.visible = false
		current_inputs.visible = false
		is_open = true

func _process(delta):
	if Input.is_action_just_pressed("ui_end"):
		is_interacting = false

func _on_chest_interacted(body):
	if is_open == false:
		is_interacting = true



func _on_input_sequence_inputs_complete():
	if is_interacting == true:
		open()
