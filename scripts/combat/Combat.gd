extends Control

var player_party: Array = []
var enemy_party: Array = []
var turn_order = []
var turn_index = 0

@onready var player_stats = $CharacterStats/PlayerStats
@onready var enemy_stats = $CharacterStats/EnemyStats
@onready var action_menu = $ActionMenu
@onready var target_selector = $TargetSelector

signal ui_update_required

func _ready():
	initialize_combat()
	if player_party.size() > 0 and enemy_party.size() > 0:
		turn_order = player_party + enemy_party
		initialize_ui()
		process_turn()
	else:
		print("No fight initialized! Make sure valid party data exists.")

func initialize_combat():
	player_party = CombatManager.player_party
	enemy_party = CombatManager.enemy_party

func initialize_ui():
	player_stats.get_children().clear()
	for player in player_party:
		var stats_row = preload("res://scenes/combat/CharacterStatsRow.tscn").instantiate()
		stats_row.get_node("VBoxContainer").get_node("NameLabel").text = player["name"]
		stats_row.get_node("VBoxContainer").get_node("HPBar").value = (player["current_health"] / player["max_health"]) * 100
		stats_row.get_node("FaceImage").texture = load(player["face_image"])
		player_stats.add_child(stats_row)

	enemy_stats.get_children().clear()
	for enemy in enemy_party:
		var stats_row = preload("res://scenes/combat/CharacterStatsRow.tscn").instantiate()
		stats_row.get_node("VBoxContainer").get_node("NameLabel").text = enemy["name"]
		stats_row.get_node("VBoxContainer").get_node("HPBar").value = (enemy["current_health"] / enemy["max_health"]) * 100
		stats_row.get_node("FaceImage").texture = load(enemy["face_image"])
		enemy_stats.add_child(stats_row)

func process_turn():
	if turn_order.size() == 0:
		print("No characters in turn order!")
		return

	var current_character = turn_order[turn_index]

	if current_character in player_party:
		show_action_menu(current_character)
	elif current_character in enemy_party:
		enemy_take_turn(current_character)

func show_action_menu(current_character):
	action_menu.visible = true
	var attack_button = action_menu.get_node("AttackButton")
	for dict in attack_button.get_signal_list():
		for sig in attack_button.get_signal_connection_list(dict.name):
			attack_button.disconnect_all(sig.signal)
	attack_button.connect("pressed", Callable(self, "_on_attack_pressed").bind(current_character))

func enemy_take_turn(enemy):
	var target = player_party[randi() % player_party.size()]
	var damage = max(0, enemy["attack"] - target.get("defense", 0))
	target["current_health"] = max(0, target["current_health"] - damage)
	print("%s attacks %s for %d damage!" % [enemy["name"], target["name"], damage])
	update_ui()
	end_turn()

func _on_attack_pressed(current_character):
	select_target(current_character, "attack")

func select_target(current_character, action):
	target_selector.visible = true
	target_selector.clear_children()

	for enemy in enemy_party:
		var button = Button.new()
		button.text = enemy["name"]
		button.connect("pressed", Callable(self, "_on_target_selected").bind(current_character, enemy, action))
		target_selector.add_child(button)

func _on_target_selected(current_character, target, action):
	if action == "attack":
		var damage = max(0, current_character["attack"] - target.get("defense", 0))
		target["current_health"] = max(0, target["current_health"] - damage)
		print("%s attacks %s for %d damage!" % [current_character["name"], target["name"], damage])
	target_selector.visible = false
	update_ui()
	end_turn()

func update_ui():
	initialize_ui()

func end_turn():
	turn_index += 1
	if turn_index >= turn_order.size():
		turn_index = 0
	process_turn()
