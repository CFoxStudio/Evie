extends CanvasLayer

func _ready():
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	$Center/Buttons/ResumeButton.grab_focus()

func _on_resume_button_pressed():
	PauseManager.toggle_pause()

func _on_exit_button_pressed():
	PauseManager.toggle_pause()
	var ch = get_tree().get_current_scene().get_node_or_null("ChapterNode")
	SaveManager.save_game(ch.chapter_num, ch.act_num)
	SceneTransition.fade("res://scenes/menus/MainMenu.tscn")
