extends CharacterBody2D

@export var speed = 125
@export var sprint_multiplier = 1.25
@export var friction = 0.1
@export var acceleration = 0.1

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('up'):
		input.y -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('right'):
		input.x += 1
	return input

func _physics_process(_delta):
	var direction = get_input()

	var current_speed = speed
	if Input.is_action_pressed('sprint'):
		current_speed *= sprint_multiplier

	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * current_speed, acceleration)
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Walk/blend_position", velocity.normalized())
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		$AnimationTree.get("parameters/playback").travel("Idle")

	move_and_slide()
