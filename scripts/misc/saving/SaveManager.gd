extends Node

var chapter : int = 0
var act : int = 0

const SAVE_PATH = "user://save_game.json"

func save_game(ch: int, a: int):
	var save_data = {
		"chapter": ch,
		"act": a
	}
	chapter = ch
	act = a
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Game saved: Chapter %d, Act %d" % [chapter, act])

func load_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	
	if file.file_exists(SAVE_PATH):
		var content = file.get_as_text()
		var save_data = JSON.parse_string(content)
		chapter = save_data.get("chapter", 0)
		act = save_data.get("act", 0)
		file.close()
		print("Game loaded: Chapter %d, Act %d" % [chapter, act])
	else:
		print("No save file found. Starting fresh.")
		chapter = 0
		act = 0
	load_scene_from_save()

func save_exists():
	return FileAccess.file_exists(SAVE_PATH)

func load_scene_from_save():
	var first_scene_path = "res://scenes/levels/ch%d/act%d/FirstScene.txt" % [chapter, act]
	if FileAccess.file_exists(first_scene_path):
		var file = FileAccess.open(first_scene_path, FileAccess.READ)
		var scene_name = file.get_as_text().strip_edges()
		file.close()
		var scene_path = "res://scenes/levels/ch%d/act%d/%s" % [chapter, act, scene_name]

		if ResourceLoader.exists(scene_path):
			var scene = load(scene_path)
			if scene:
				SceneTransition.fade(scene_path)
			else:
				print("Failed to load scene: %s" % scene_path)
		else:
			print("Scene file does not exist: %s" % scene_path)
	else:
		print("FirstScene.txt file does not exist at path: %s" % first_scene_path)
