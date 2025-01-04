extends Node

var player_party: Array = []
var enemy_party: Array = []
var combat_background: String = "res://assets/combat_backgrounds/test_background.png"
var scene_after: String = "res://scenes/levels/ch-1/act-1/TestLevel.tscn"

signal combat_started
signal combat_ended

func start_combat(players: Array, enemies: Array, background: String = "", scene_after: String = ""):
	player_party = load_characters(players)
	enemy_party = load_characters(enemies)
	if background != "":
		combat_background = background
	if scene_after != "":
		self.scene_after = scene_after
	SceneTransition.fade("res://scenes/combat/Combat.tscn")
	emit_signal("combat_started")

func end_combat():
	enemy_party.clear()
	SceneTransition.fade(scene_after)
	emit_signal("combat_ended")

func is_combat_active() -> bool:
	return player_party.size() > 0 and enemy_party.size() > 0

func load_characters(paths: Array) -> Array:
	var party = []
	for path in paths:
		if FileAccess.file_exists(path):
			var file = FileAccess.open(path, FileAccess.READ)
			var content = file.get_as_text()
			var parse_result = JSON.parse_string(content)
			var character_data = parse_result
			if typeof(character_data) == TYPE_DICTIONARY:
				party.append(character_data)
			else:
				print("Failed to parse character data from: %s" % path)
			file.close()
		else:
			print("File does not exist: %s" % path)
	return party
