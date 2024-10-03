extends Node

const ACHIEVEMENTS_FILE := "res://data/achievements.json"
const SAVE_FILE := "user://save/achievements.json"
var all_achievements = {}
var unlocked_achievements = {}

func _ready():
	load_achievements()
	load_unlocked_achievements()

func unlock_achievement(achievement_name: String):
	if achievement_name in unlocked_achievements:
		return

	for achievement in all_achievements:
		if achievement["name"] == achievement_name:
			unlocked_achievements[achievement_name] = true
			save_unlocked_achievements()
			GameJoltHelper.trophy(achievement["gamejolt_id"])
			print("Achievement unlocked: %s" % achievement["name"])
			return

func load_achievements():
	var achievements_file = FileAccess.open(ACHIEVEMENTS_FILE, FileAccess.READ)
	if achievements_file:
		var json = JSON.new()
		var content = achievements_file.get_as_text()
		all_achievements = json.parse_string(content)
		achievements_file.close()

func load_unlocked_achievements():
	var save_file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if save_file:
		var json = JSON.new()
		var content = save_file.get_as_text()
		unlocked_achievements = json.parse_string(content)
		save_file.close()
	else:
		unlocked_achievements = {}

func save_unlocked_achievements():
	var save_file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	var json = JSON.new()
	save_file.store_string(JSON.stringify(unlocked_achievements))
	save_file.close()
