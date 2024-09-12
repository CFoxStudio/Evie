extends CharacterBody2D

@export var speed = 100
@export var sprint_multiplier = 1.30

func get_input() -> Vector2:
	var input_vector = Vector2()
	
	if Input.is_action_pressed('up'):
		input_vector.y -= 1
	if Input.is_action_pressed('down'):
		input_vector.y += 1
	if Input.is_action_pressed('left'):
		input_vector.x -= 1
	if Input.is_action_pressed('right'):
		input_vector.x += 1

	return input_vector.normalized()

func _physics_process(_delta):
	var direction = get_input()
	var current_speed = speed
	if Input.is_action_pressed('sprint'):
		current_speed *= sprint_multiplier

	if direction != Vector2.ZERO:
		velocity = direction * current_speed
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Walk/blend_position", direction)
	else:
		velocity = Vector2.ZERO
		$AnimationTree.get("parameters/playback").travel("Idle")

	move_and_slide()
