extends Control

func _ready():
	$AnimationPlayer.play_backwards("fade")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("fade")
	await $AnimationPlayer.animation_finished
	$Logo.texture = load("res://assets/misc/godot.svg")
	$Name.text = "Made using Godot 4"
	$AnimationPlayer.play_backwards("fade")
	await $AnimationPlayer.animation_finished
	SceneTransition.fade("res://scenes/menus/MainMenu.tscn")
	
