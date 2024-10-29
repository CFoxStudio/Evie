extends Node

signal cutscene_started
signal cutscene_finished

@export var player: Node

var action_queue: Array = []
var current_action_index := 0
var is_running := false

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
	
	if (Dialogic.timeline_ended.is_connected(_process_next_action)):
		Dialogic.timeline_ended.disconnect(_process_next_action)

	var action = action_queue[current_action_index]
	current_action_index += 1

	match action["type"]:
		"move_npc":
			_move_npc(action["npc"], action["target_position"], action.get("speed", 100))
		"animate_npc":
			# target_position has a default value for animations like jump which don't use it
			_animate_npc(action["npc"], action["animation"], action.get("target_position", Vector2(0,0)), action.get("speed", 100))
		"destroy_npc":
			_destroy_npc(action["npc"])
		"show_dialogue":
			_show_dialogue(action["timeline"])
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

func _animate_npc(npc: Node2D, animation_type: String, target_position: Vector2, speed: float) -> void:
	match animation_type:
		"jump":
			var jump_height = 10.0
			var jump_duration = jump_height / speed
			var jump_up_position = npc.position + Vector2(0, -jump_height)
			
			var jump_tween = create_tween()
			jump_tween.tween_property(npc, "position", jump_up_position, jump_duration / 2)
			jump_tween.tween_property(npc, "position", npc.position, jump_duration / 2)
			
			await jump_tween.finished
			
		"move": # Has meme potential
			var direction = (target_position - npc.position).normalized()
			var distance = npc.position.distance_to(target_position)
			
			var move_tween = create_tween()
			move_tween.tween_property(npc, "position", target_position, distance / speed)
			
			await move_tween.finished
	_process_next_action()

func _destroy_npc(npc: Node2D) -> void:
	npc.queue_free()
	_process_next_action()

func _show_dialogue(timeline: Variant):
	Dialogic.timeline_ended.connect(_process_next_action)
	Dialogic.start(timeline)

func _end_cutscene() -> void:
	player.allow_movement(true)
	emit_signal("cutscene_finished")
	is_running = false
	player.allow_movement(true);
