extends Node

var pause_menu_scene = preload("res://scenes/menus/PauseMenu.tscn")
var pause_menu_instance: CanvasLayer = null
var is_paused = false

func _ready():
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause():
	if is_paused:
		unpause_game()
	else:
		pause_game()

func pause_game():
	if pause_menu_instance == null:
		pause_menu_instance = pause_menu_scene.instantiate()
		
		get_viewport().add_child(pause_menu_instance)
		
		chapter_info()
		pause_menu_instance.visible = true
		get_tree().paused = true
		is_paused = true

func unpause_game():
	if pause_menu_instance != null:
		pause_menu_instance.queue_free()
		pause_menu_instance = null

	get_tree().paused = false
	is_paused = false

func chapter_info():
	var chapter_node = get_tree().get_current_scene().get_node_or_null("ChapterNode")
	if pause_menu_instance != null:
		if chapter_node != null:
			var chapter_number = chapter_node.chapter_num
			var chapter_name = chapter_node.chapter_name
			
			pause_menu_instance.get_node("ChAct/Chapter").text = "Chapter " + str(chapter_number) + ": " + chapter_name
			pause_menu_instance.get_node("ChAct/Act").text = "Act " + str(chapter_number) + ": " + chapter_name
