extends Node

signal cutscene_started
signal cutscene_finished

@export var player: Node

var action_queue: Array = []
var current_action_index := 0
var is_running := false

func _ready() -> void:
	if player:
		player.allow_movement(false)
	else:
		push_error("CutsceneManager: 'player' is not assigned in the Inspector")

func start_cutscene(actions: Array) -> void:
	if is_running:
		return
	is_running = true
	action_queue = actions
	current_action_index = 0
	player.allow_movement(false);

	emit_signal("cutscene_started")
	_process_next_action()

func _process_next_action() -> void:
	if current_action_index >= action_queue.size():
		_end_cutscene()
		return

	var action = action_queue[current_action_index]
	current_action_index += 1

	match action["type"]:
		"move_npc":
			_move_npc(action["npc"], action["target_position"], action.get("speed", 100))
		"wait":
			await get_tree().create_timer(action["time"]).timeout
			_process_next_action()

func _move_npc(npc: Node2D, target_position: Vector2, speed: float) -> void:
	var direction = (target_position - npc.position).normalized()
	var distance = npc.position.distance_to(target_position)
	
	var tween = create_tween()
	tween.tween_property(npc, "position", target_position, distance / speed)

	var animation_tree = npc.get_node("AnimationTree") if npc.has_node("AnimationTree") else null
	if animation_tree:
		animation_tree.get("parameters/playback").call("travel", "Walk")
		animation_tree.set("parameters/Walk/blend_position", direction)

	await tween.finished
	if animation_tree:
		animation_tree.get("parameters/playback").call("travel", "Idle")
	_process_next_action()


func _end_cutscene() -> void:
	player.allow_movement(true)
	emit_signal("cutscene_finished")
	is_running = false
	player.allow_movement(true);
