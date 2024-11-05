extends Node

var quests = {}

func create(quest_name: String, quest_desc: String, max_progress: int):
	if quest_name in quests:
		print("Quest " + quest_name + " already exists!")
	else:
		quests[quest_name] = {"desc": quest_desc, "progress": 0, "max_progress": max_progress}
		print("Quest added: " + quest_name)

func add_progress(quest_name: String, progress: int):
	if quest_name in quests:
		quests[quest_name]["progress"] += progress
		print("Progress added to quest: " + quest_name + " | Progress: " + str(quests[quest_name]["progress"]))
		if quests[quest_name]["progress"] >= quests[quest_name]["max_progress"]:
			remove(quest_name)
	else:
		print("Quest " + quest_name + " not found!")

func remove(quest_name: String):
	if quest_name in quests:
		quests.erase(quest_name)
		print("Quest removed: " + quest_name)
	else:
		print("Quest " + quest_name + " not found!")

func exists(quest_name: String):
	return quests.has(quest_name)

func get_quests() -> Dictionary:
	return quests

func get_progress(quest_name: String) -> String:
	if quest_name in quests:
		return "%d/%d" % [quests[quest_name]["progress"], quests[quest_name]["max_progress"]]
	else:
		print("Quest " + quest_name + " not found!")
		return "Quest not found"
