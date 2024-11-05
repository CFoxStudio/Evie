extends CanvasLayer

var quest_descriptions

func _ready():
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	$Center/Buttons/ResumeButton.grab_focus()
	update_quest_display()
	$Quests/QuestList.connect("item_selected", Callable(self, "_on_quest_selected"))

func _process(delta):
	var time = Time.get_time_dict_from_system()
	$TimeLabel.text = "%02d:%02d:%02d" % [time.hour, time.minute, time.second]

func _on_resume_button_pressed():
	PauseManager.toggle_pause()

func _on_exit_button_pressed():
	PauseManager.toggle_pause()
	var ch = get_tree().get_current_scene().get_node_or_null("ChapterNode")
	SaveManager.save_game(ch.chapter_num, ch.act_num)
	SceneTransition.fade("res://scenes/menus/MainMenu.tscn")

# Update Quest list
func update_quest_display():
	var quest_list: ItemList = $Quests/QuestList
	quest_list.clear()

	var quest_data = QuestManager.get_quests()  
	for quest_name in quest_data.keys():
		var quest_info = quest_data[quest_name]
		var progress_text = "%s (%d/%d)" % [quest_name, quest_info["progress"], quest_info["max_progress"]]
		quest_list.add_item(progress_text)
	quest_descriptions = quest_data

# Show Quest Description on click
func _on_quest_selected(index):
	var quest_name = $Quests/QuestList.get_item_text(index).split(" (")[0]
	if quest_name in quest_descriptions:
		var quest_info = quest_descriptions[quest_name]
		$Quests/QuestList.set_item_text(index, quest_info["desc"])
