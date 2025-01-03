@tool
extends Control

@onready var name_input = $VBoxContainer/NameFaceContainer/NameInput
@onready var max_health_input = $VBoxContainer/HealthAttackContainer/HBoxContainer/MaxHealthInput
@onready var attack_input = $VBoxContainer/HealthAttackContainer/HBoxContainer/AttackInput
@onready var face_image_path = $VBoxContainer/NameFaceContainer/FaceVBoxContainer/FaceImagePath
@onready var face_image_dialog = $VBoxContainer/FaceImageDialog

func _ready():
	$VBoxContainer/NameFaceContainer/FaceVBoxContainer/BrowseFaceImage.connect("pressed", Callable(self, "_on_browse_face_image"))
	$VBoxContainer/SaveButton.connect("pressed", Callable(self, "_on_save_character"))
	face_image_dialog.connect("file_selected", Callable(self, "_on_face_image_selected"))

func _on_browse_face_image():
	face_image_dialog.popup()

func _on_face_image_selected(path):
	face_image_path.text = path

func _on_save_character():
	var character_data = {
		"name": name_input.text,
		"max_health": max_health_input.value,
		"attack": attack_input.value,
		"face_image": face_image_path.text
	}
	
	var characters_dir = "res://data/characters"
	var dir = DirAccess.open("res://")
	if not dir.dir_exists(characters_dir):
		dir.make_dir(characters_dir)

	var file_path = characters_dir + "/" + character_data["name"] + ".json"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(character_data, "\t"))
		file.close()
		print("Character saved to:", file_path)
		var success_window = Window.new()
	else:
		print("Failed to save character.")
