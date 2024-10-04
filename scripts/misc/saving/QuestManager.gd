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
	else:
		print("Quest " + quest_name + " not found!")

func remove(quest_name: String):
	if quest_name in quests:
		quests.erase(quest_name)
		print("Quest removed: " + quest_name)
	else:
		print("Quest " + quest_name + " not found!")

func get_quests():
	for quest_name in quests.keys():
		print("Quest: " + quest_name + " | Description: " + quests[quest_name]["desc"])

func get_progress(quest_name: String):
	if quest_name in quests:
		return (str(quests[quest_name]["progress"] + "/" + quests[quest_name]["max_progresss"]))
	else:
		print("Quest " + quest_name + " not found!")
