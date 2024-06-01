extends Control

@onready var tutorial_button = $MarginContainer/HBoxContainer/VBoxContainer/TutorialButton
@onready var host_button = $MarginContainer/HBoxContainer/VBoxContainer/HostButton
@onready var join_button = $MarginContainer/HBoxContainer/VBoxContainer/JoinButton

@onready var tutorialLevel = preload("res://scenes/test_world.tscn")

func _ready():
	pass



func _process(delta):
	pass




func tutorial_button_pressed():
	get_tree().change_scene_to_file("res://scenes/test_world.tscn")
