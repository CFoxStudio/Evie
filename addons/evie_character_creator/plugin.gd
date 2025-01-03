@tool
extends EditorPlugin

const CharacterCreator := preload("res://addons/evie_character_creator/CharacterCreator.tscn")
var editor_view: Control

func _enter_tree() -> void:
	editor_view = CharacterCreator.instantiate()
	editor_view.hide()
	get_editor_interface().get_editor_main_screen().add_child(editor_view)

func _exit_tree() -> void:
	if editor_view:
		editor_view.queue_free()

func _has_main_screen() -> bool:
	return true

func _get_plugin_icon() -> Texture2D:
	var original_icon = load("res://addons/evie_character_creator/icon.png") as Texture2D
	var resized_image = original_icon.get_image()
	resized_image.resize(16, 16, Image.INTERPOLATE_CUBIC)
	
	var resized_texture = ImageTexture.create_from_image(resized_image)
	return resized_texture

func _get_plugin_name() -> String:
	return "Character Creator"

func _make_visible(visible: bool) -> void:
	if not editor_view:
		return

	if visible:
		editor_view.show()
		editor_view.get_parent().move_child(editor_view, 0)
		editor_view.grab_focus()
	else:
		editor_view.hide()
