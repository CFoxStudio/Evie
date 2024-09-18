extends Control

func _ready():
	$Center/Buttons/ContinueButton.grab_focus()

func _on_exit_button_pressed():
	SceneTransition.fade("res://scenes/menus/MainMenu.tscn")
