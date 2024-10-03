extends Control

func _ready():
	GameJoltHelper.login()
	AchievementManager.unlock_achievement("First Signal")
	$Panel/MainButtons/PlayButton.grab_focus()

func _on_play_button_pressed():
	if (SaveManager.save_exists()):
		SaveManager.load_game()
	else:
		SaveManager.save_game(-1, -1)
		SceneTransition.fade("res://scenes/levels/ch-1/act-1/TestLevel.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
