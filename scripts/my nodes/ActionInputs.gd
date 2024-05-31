extends Node
#when using arrow keys of a key that requires more than one letter (DownUpDownLeftRight) for example

#region input export vars
@export var input1 = ""
@export var input2 = ""
@export var input3 = ""
@export var input4 = ""
@export var input5 = ""
@export var input6 = ""
@export var input7 = ""
@export var input8 = ""
@export var input9 = ""
@export var input10 = ""
@export var input11 = ""
@export var input12 = ""
@export var input13 = ""
@export var input14 = ""
@export var input15 = ""
@export var input16 = ""
@export var number_of_inputs: int
#endregion
@onready var needed_inputs = Labels.get_node("neededInputs")
@onready var current_inputs = Labels.get_node("currentInputs")
@onready var NextInputImage = Labels.get_node("NextInputImage")

@onready var UpImage = preload("res://assets/images/up arrow.png")
@onready var DownImage = preload("res://assets/images/down arrow.png")
@onready var LeftImage = preload("res://assets/images/left arrow arrow.png")
@onready var RightImage = preload("res://assets/images/right arrow.png")

signal InputsComplete


var inputnum = 0

var InputImage = ""
var keyboard_input = ""
var is_interacting

var reloading

func _process(delta):
	
	Next_Input_Image()
	


func Next_Input_Image():
#region InputImage ifs
	if inputnum == 0:
		InputImage = input1
	if inputnum == 1:
		InputImage = input2
	if inputnum == 2:
		InputImage = input3
	if inputnum == 3:
		InputImage = input4
	if inputnum == 4:
		InputImage = input5
	if inputnum == 5:
		InputImage = input6
	if inputnum == 6:
		InputImage = input7
	if inputnum == 7:
		InputImage = input8
	if inputnum == 8:
		InputImage = input9
	if inputnum == 9:
		InputImage = input10
	if inputnum == 10:
		InputImage = input11
	if inputnum == 11:
		InputImage = input12
	if inputnum == 12:
		InputImage = input13
	if inputnum == 13:
		InputImage = input14
	if inputnum == 14:
		InputImage = input15
	if inputnum == 15:
		InputImage = input16
#endregion
	
	if is_interacting == true or reloading:
		if InputImage.contains("Up") :
			NextInputImage.texture = UpImage
		if InputImage.contains("Down") :
			NextInputImage.texture = DownImage
		if InputImage.contains("Left") :
			NextInputImage.texture = LeftImage
		if InputImage.contains("Right") :
			NextInputImage.texture = RightImage
		

func _input(event):
	if event is InputEventKey and event.is_pressed() and is_interacting == true or event is InputEventKey and event.is_pressed() and reloading == true:
		
		var key_name_1 = ""
		for action in InputMap.action_get_events("ActionUp"):
			if action is InputEventKey:
				key_name_1 = OS.get_keycode_string(action.physical_keycode)
		var key_name_2 = ""
		for action in InputMap.action_get_events("ActionDown"):
			if action is InputEventKey:
				key_name_2 = OS.get_keycode_string(action.physical_keycode)
		var key_name_3 = ""
		for action in InputMap.action_get_events("ActionLeft"):
			if action is InputEventKey:
				key_name_3 = OS.get_keycode_string(action.physical_keycode)
		var key_name_4 = ""
		for action in InputMap.action_get_events("ActionRight"):
			if action is InputEventKey:
				key_name_4 = OS.get_keycode_string(action.physical_keycode)
		if event.as_text() == key_name_1 or event.as_text() == key_name_2 or event.as_text() == key_name_3 or event.as_text() == key_name_4:
			needed_inputs.text = "Needed Inputs: "
			keyboard_input.erase(0,1)
			inputnum += 1
			keyboard_input += str(inputnum) + event.as_text()
			if keyboard_input.contains("Esc"):
				is_interacting = false
			input_check()
			if inputnum > 16:
				keyboard_input = ""
				inputnum = 0
			print(keyboard_input)
			current_inputs.text = "Current Inputs: " + str(keyboard_input)

func reset():
	inputnum = 0
	keyboard_input = ""

func input_check():
	if inputnum == 1 and keyboard_input.contains("1" + input1):
		if number_of_inputs == 1:
			emit_signal("InputsComplete")
			NextInputImage.texture = null
			reloading = false
			is_interacting = false
			reset()
	elif inputnum == 1 and not keyboard_input.contains("1" + input1):
		keyboard_input = ""
		inputnum = 0
		reset()
	if inputnum == 2 and keyboard_input.contains("2" + input2):
		print(keyboard_input)
		if number_of_inputs == 2:
			emit_signal("InputsComplete")
			NextInputImage.texture = null
			reloading = false
			is_interacting = false
			reset()
	elif inputnum == 2 and not keyboard_input.contains("2" + input2):
		keyboard_input = ""
		inputnum = 0
		reset()
	if inputnum == 3 and keyboard_input.contains("3" + input3):
		print(keyboard_input)
		if number_of_inputs == 3:
			emit_signal("InputsComplete")
			NextInputImage.texture = null
			reloading = false
			is_interacting = false
			reset()
	elif inputnum == 3 and not keyboard_input.contains("3" + input3):
		keyboard_input = ""
		inputnum = 0
		reset()
	if inputnum == 4 and keyboard_input.contains("4" + input4):
		print(keyboard_input)
		if number_of_inputs == 4:
			emit_signal("InputsComplete")
			NextInputImage.texture = null
			reloading = false
			is_interacting = false
			reset()
	elif inputnum == 4 and not keyboard_input.contains("4" + input4):
		keyboard_input = ""
		inputnum = 0
		reset()
	if inputnum == 5 and keyboard_input.contains("5" + input5):
		print(keyboard_input)
		if number_of_inputs == 5:
			emit_signal("InputsComplete")
			NextInputImage.texture = null
			reloading = false
			is_interacting = false
			reset()
	elif inputnum == 5 and not keyboard_input.contains("5" + input5):
		keyboard_input = ""
		inputnum = 0
		reset()
	if inputnum == 6 and keyboard_input.contains("6" + input6):
		print(keyboard_input)
		if number_of_inputs == 6:
			emit_signal("InputsComplete")
			NextInputImage.texture = null
			reloading = false
			is_interacting = false
			reset()
	elif inputnum == 6 and not keyboard_input.contains("6" + input6):
		keyboard_input = ""
		inputnum = 0
		reset()
	if inputnum == 7 and keyboard_input.contains("7" + input7):
		print(keyboard_input)
		if number_of_inputs == 7:
			emit_signal("InputsComplete")
			NextInputImage.texture = null
			reloading = false
			is_interacting = false
			reset()
	elif inputnum == 7 and not keyboard_input.contains("7" + input7):
		keyboard_input = ""
		inputnum = 0
		reset()
	if inputnum == 8 and keyboard_input.contains("8" + input8):
		print(keyboard_input)
		if number_of_inputs == 8:
			emit_signal("InputsComplete")
			NextInputImage.texture = null
			reloading = false
			is_interacting = false
			reset()
	elif inputnum == 8 and not keyboard_input.contains("8" + input8):
		keyboard_input = ""
		inputnum = 0
		reset()
	if inputnum == 9 and keyboard_input.contains("9" + input9):
		print(keyboard_input)
		if number_of_inputs == 9:
			emit_signal("InputsComplete")
			NextInputImage.texture = null
			reloading = false
			is_interacting = false
			reset()
	elif inputnum == 9 and not keyboard_input.contains("9" + input9):
		keyboard_input = ""
		inputnum = 0
		reset()
	if inputnum == 10 and keyboard_input.contains("10" + input10):
		print(keyboard_input)
		if number_of_inputs == 10:
			emit_signal("InputsComplete")
			NextInputImage.texture = null
			reloading = false
			is_interacting = false
			reset()
	elif inputnum == 10 and not keyboard_input.contains("10" + input10):
		keyboard_input = ""
		inputnum = 0
		reset()
	if inputnum == 11 and keyboard_input.contains("11" + input11):
		print(keyboard_input)
		if number_of_inputs == 11:
			emit_signal("InputsComplete")
			NextInputImage.texture = null
			reloading = false
			is_interacting = false
			reset()
	elif inputnum == 11 and not keyboard_input.contains("11" + input11):
		keyboard_input = ""
		inputnum = 0
		reset()
	if inputnum == 12 and keyboard_input.contains("12" + input12):
		print(keyboard_input)
		if number_of_inputs == 12:
			emit_signal("InputsComplete")
			NextInputImage.texture = null
			reloading = false
			is_interacting = false
			reset()
	elif inputnum == 12 and not keyboard_input.contains("12" + input12):
		keyboard_input = ""
		inputnum = 0
		reset()
	if inputnum == 13 and keyboard_input.contains("13" + input13):
		print(keyboard_input)
		if number_of_inputs == 13:
			emit_signal("InputsComplete")
			NextInputImage.texture = null
			reloading = false
			is_interacting = false
			reset()
	elif inputnum == 13 and not keyboard_input.contains("13" + input13):
		keyboard_input = ""
		inputnum = 0
		reset()
	if inputnum == 14 and keyboard_input.contains("14" + input14):
		print(keyboard_input)
		if number_of_inputs == 14:
			emit_signal("InputsComplete")
			NextInputImage.texture = null
			reloading = false
			is_interacting = false
			reset()
	elif inputnum == 14 and not keyboard_input.contains("14" + input14):
		keyboard_input = ""
		inputnum = 0
		reset()
	if inputnum == 15 and keyboard_input.contains("15" + input15):
		print(keyboard_input)
		if number_of_inputs == 15:
			emit_signal("InputsComplete")
			NextInputImage.texture = null
			reloading = false
			is_interacting = false
			reset()
	elif inputnum == 15 and not keyboard_input.contains("15" + input15):
		keyboard_input = ""
		inputnum = 0
		reset()
	if inputnum == 16 and keyboard_input.contains("16" + input16):
		print(keyboard_input)
		if number_of_inputs == 16:
			emit_signal("InputsComplete")
			NextInputImage.texture = null
			reloading = false
			is_interacting = false
			reset()
	elif inputnum == 16 and not keyboard_input.contains("16" + input16):
		keyboard_input = ""
		inputnum = 0
		reset()



func _on_interacted(body):
	is_interacting = true




func _on_reloading():
	reloading = true


func _on_weapon_unequipped():
	reloading = false
	NextInputImage.texture = null
