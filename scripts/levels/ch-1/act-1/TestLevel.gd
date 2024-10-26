extends Node2D

var is_player_inside_godot1 = false
var godot1_found = false
var is_player_inside_godot2 = false
var godot2_found = false

func _ready():
	QuestManager.create("Godot Fan", "Find and click on 2 Godot icons", 2)
	
	var cutscene_actions = [
		{"type": "move_npc", "npc": $Player, "target_position": Vector2(275, 100), "speed": 40},
		{"type": "move_npc", "npc": $Player, "target_position": Vector2(275, 200), "speed": 40}
	]
	$CutsceneManager.connect("cutscene_finished", Callable(self, "_on_test_cutscene_finished"))
	$CutsceneManager.start_cutscene(cutscene_actions)

func _input(event):
	if is_player_inside_godot1 and event.is_action_pressed("interact") and !godot1_found:
		godot1_found = true
		QuestManager.add_progress("Godot Fan", 1)
	elif is_player_inside_godot2 and event.is_action_pressed("interact") and !godot2_found:
		godot2_found = true
		QuestManager.add_progress("Godot Fan", 1)

func _on_godot_1_body_entered(body):
	if body.name == "Player":
		is_player_inside_godot1 = true

func _on_godot_1_body_exited(body):
	if body.name == "Player":
		is_player_inside_godot1 = false

func _on_godot_2_body_entered(body):
	if body.name == "Player":
		is_player_inside_godot2 = true

func _on_godot_2_body_exited(body):
	if body.name == "Player":
		is_player_inside_godot2 = false

func _on_test_cutscene_finished():
	Dialogic.start("res://dialogues/dialogues/tests/Test.dtl")
