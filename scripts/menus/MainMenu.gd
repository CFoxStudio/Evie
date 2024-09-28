extends Control

func _ready():
	$Panel/MainButtons/PlayButton.grab_focus()

func _on_play_button_pressed():
	SceneTransition.fade("res://scenes/levels/test/TestLevel.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
