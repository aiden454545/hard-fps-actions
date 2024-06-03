extends Control



@onready var tutorial_button = $VBoxContainer/TutorialButton
@onready var tutorialLevel = preload("res://scenes/test_world.tscn")




func tutorial_button_pressed():
	get_tree().change_scene_to_file("res://scenes/test_world.tscn")
