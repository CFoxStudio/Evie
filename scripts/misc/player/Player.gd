extends CharacterBody2D

@export var speed: float = 100
@export var sprint_multiplier: float = 1.3

var can_move: bool = true
var cutscene_manager = null
var move_vector := Vector2.ZERO

func _ready():
	cutscene_manager = get_parent().get_node("CutsceneManager") if get_parent().has_node("CutsceneManager") else null

func _physics_process(delta):
	move_vector = Input.get_vector("left", "right", "up", "down")
	var current_speed = speed
	
	if Input.is_action_pressed('sprint'):
		current_speed *= sprint_multiplier
	
	if can_move and move_vector != Vector2.ZERO:
		velocity = move_vector * current_speed
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Walk/blend_position", move_vector)
	else:
		velocity = Vector2.ZERO
		if (cutscene_manager != null and not cutscene_manager.is_running) or cutscene_manager == null:
			$AnimationTree.get("parameters/playback").travel("Idle")
	
	move_and_slide()

func allow_movement(allow: bool):
	can_move = allow

func show_interact_button(show: bool):
	$UI/Buttons/ControlButtonsContainer/InteractionButton.visible = show
