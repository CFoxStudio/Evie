@tool
extends Control

@onready var name_input = $VBoxContainer/NameFaceContainer/NameInput
@onready var max_health_input = $VBoxContainer/HealthAttackContainer/HBoxContainer/MaxHealthInput
@onready var attack_input = $VBoxContainer/HealthAttackContainer/HBoxContainer/AttackInput
@onready var face_image_path = $VBoxContainer/NameFaceContainer/FaceVBoxContainer/FaceImagePath
@onready var face_image_dialog = $VBoxContainer/FaceImageDialog
@onready var load_character_dialog = $VBoxContainer/LoadCharacterDialog

func _ready():
	$VBoxContainer/NameFaceContainer/FaceVBoxContainer/BrowseFaceImage.connect("pressed", Callable(self, "_on_browse_face_image"))
	$VBoxContainer/SaveButton.connect("pressed", Callable(self, "_on_save_character"))
	$VBoxContainer/LoadButton.connect("pressed", Callable(self, "_on_load_character"))
	face_image_dialog.connect("file_selected", Callable(self, "_on_face_image_selected"))
	load_character_dialog.connect("file_selected", Callable(self, "_on_character_file_selected"))

func _on_browse_face_image():
	face_image_dialog.popup()

func _on_face_image_selected(path):
	face_image_path.text = path

func _on_save_character():
	var character_data = {
		"name": name_input.text,
		"max_health": max_health_input.value,
		"current_health": max_health_input.value,
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
		print("Character saved to: ", file_path)
	else:
		print("Failed to save character.")

func _on_load_character():
	load_character_dialog.popup()

func _on_character_file_selected(path):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var file_content = file.get_as_text()
		file.close()
		
		var character_data = JSON.parse_string(file_content)
		if character_data and character_data.has("name") and character_data.has("max_health") and character_data.has("attack") and character_data.has("face_image"):
			name_input.text = character_data["name"]
			max_health_input.value = character_data["max_health"]
			attack_input.value = character_data["attack"]
			face_image_path.text = character_data["face_image"]
			print("Character loaded from: ", path)
		else:
			print("Invalid character file format: ", path)
	else:
		print("Failed to open file: ", path)
