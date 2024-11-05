extends Control

func _ready():
	# CelestialFox Logo
	$AnimationPlayer.play_backwards("fade")
	await $AnimationPlayer.animation_finished
	# Godot Logo
	$AnimationPlayer.play("fade")
	await $AnimationPlayer.animation_finished
	$Logo.texture = load("res://assets/misc/godot.svg")
	$Name.text = "Made using Godot 4"
	# Scene change to Main Menu
	$AnimationPlayer.play_backwards("fade")
	await $AnimationPlayer.animation_finished
	SceneTransition.fade("res://scenes/menus/MainMenu.tscn")
	
