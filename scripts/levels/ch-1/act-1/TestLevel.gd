extends Node2D

var godot1_found = false
var godot2_found = false
var evie_npc: Node = null

func _ready():
	QuestManager.create("Godot Fan", "Find and use the action button on 2 Godot icons", 2)
	
	var cutscene_actions = [
		{"type": "move_npc", "npc": $Player, "target_position": Vector2(275, 100), "speed": 40},
		{"type": "move_npc", "npc": $Player, "target_position": Vector2(275, 200), "speed": 40},
		{"type": "show_dialogue", "timeline": "res://dialogues/dialogues/tests/Test.dtl"},
		{"type": "animate_npc", "npc": $Player, "animation": "jump", "speed": 50}
	]
	$CutsceneManager.start_cutscene(cutscene_actions)
	evie_npc = $EvieButNPC

func _process(delta):
	# A small testing quest
	if GameUtils.is_inside_area($QuestGodots/Godot1, $Player):
		if Input.is_action_just_pressed("interact") and !godot1_found:
			godot1_found = true
			QuestManager.add_progress("Godot Fan", 1)
	if GameUtils.is_inside_area($QuestGodots/Godot2, $Player):
		if Input.is_action_just_pressed("interact") and !godot2_found:
			godot2_found = true
			QuestManager.add_progress("Godot Fan", 1)
	
	# Test (meme) cutscene
	if evie_npc and GameUtils.is_inside_area($EvieButNPC, $Player):
		if Input.is_action_just_pressed("interact"):
			var evie_cutscene = [
				{"type": "show_dialogue", "timeline": "res://dialogues/dialogues/tests/Wait.dtl"},
				{"type": "animate_npc", "npc": $EvieButNPC, "animation": "move", "target_position": Vector2(520, -50), "speed": 10},
				{"type": "destroy_npc", "npc": $EvieButNPC}
			]
			$CutsceneManager.start_cutscene(evie_cutscene)
			evie_npc = null
