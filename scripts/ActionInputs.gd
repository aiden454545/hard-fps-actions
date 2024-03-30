extends Node
#when using arrow keys of a key that requires more than one letter (DownUpDownLeftRight) for example

@export var targetInputs = ""
@export var stringLength : int

var keyboard_input = ""

#func _input(event):
#	if event is InputEventKey and event.is_pressed():
#		keyboard_input.erase(0,1)
#		keyboard_input += event.as_text()
#		print(keyboard_input)
#		if keyboard_input == targetInputs and keyboard_input.length() <= stringLength:
#			print("User just typed 'egg'")
#			keyboard_input = ""
#		elif keyboard_input.length() > stringLength or keyboard_input.contains("R"):
#			keyboard_input = ""



