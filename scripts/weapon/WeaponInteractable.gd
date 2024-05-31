class_name WeaponInteractable
extends Node3D

@export var prompt_message = "Interact"
@export var prompt_action = "interact"

signal interacted(body)
signal dropped(body)

func get_prompt():
	var key_name = ""
	for action in InputMap.action_get_events("interact"):
		if action is InputEventKey:
			key_name = OS.get_keycode_string(action.physical_keycode)
	return prompt_message + "
	" + "\n[" + key_name + "]"

func interact(body):
	emit_signal("interacted", body)
	print(body)

func drop(body):
	emit_signal("dropped", body)

