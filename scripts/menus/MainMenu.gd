extends Control

# Music loop variables
@export var loop_start_time: float = 20.57
@export var loop_end_time: float = 0.0

func _ready():
	$CanvasLayer/Panel/GameVersionLabel.text = ProjectSettings.get_setting("application/config/version")
	GameJoltHelper.login()
	AchievementManager.unlock_achievement("First Signal")
	$CanvasLayer/Panel/MainButtons/PlayButton.grab_focus()
	
	var audio_player = $MenuMusicPlayer
	if loop_end_time == 0.0:
		loop_end_time = audio_player.stream.get_length()
	audio_player.play()

func _process(delta):
	var audio_player = $MenuMusicPlayer
	var playback_position = audio_player.get_playback_position()
	if audio_player.playing and playback_position >= loop_end_time - 0.05:
		audio_player.seek(loop_start_time)

func _on_play_button_pressed():
	if SaveManager.save_exists():
		SaveManager.load_game()
	else:
		SaveManager.save_game(-1, -1)
	SceneTransition.fade("res://scenes/levels/ch-1/act-1/TestLevel.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
