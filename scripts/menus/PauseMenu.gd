extends CanvasLayer

func _ready():
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	$Center/Buttons/ResumeButton.grab_focus()

func _on_resume_button_pressed():
	PauseManager.toggle_pause()

func _on_exit_button_pressed():
	PauseManager.toggle_pause()
	# Save here
	# SaveManager.save()
	SceneTransition.fade("res://scenes/menus/MainMenu.tscn")
