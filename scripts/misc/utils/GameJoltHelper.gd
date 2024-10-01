extends Node

var config = ConfigFile.new()
var credentials_file = "user://credentials.cfg"

var trophie: String

func _init():
	GameJolt.trophies_fetch_completed.connect(_on_trophies_fetch_completed)

func save_login(user: String, token: String):
	config.set_value("credentials", "username", user)
	config.set_value("credentials", "token", token)
	config.save(credentials_file)
	print("Credentials saved")

func load_login() -> Dictionary:
	var err = config.load(credentials_file)
	if err == OK:
		var username = config.get_value("credentials", "username", null)
		var token = config.get_value("credentials", "token", null)
		return {"username": username, "token": token}
	return {}

func login():
	var credentials = load_login()
	if credentials.has("username") and credentials.has("token"):
		var username = credentials["username"]
		var token = credentials["token"]
		GameJolt.set_user_name(username)
		GameJolt.set_user_token(token)
		GameJolt.users_auth()
		
		print("Logged in with saved credentials: ", username)
	else:
		print("No saved credentials found.")

func trophy(trophy_id: String):
	print("Connecting to trophies_fetch_completed signal...")
	trophie = trophy_id
	GameJolt.trophies_fetch(true)

func _on_trophies_fetch_completed(trophies: Dictionary):
	print("Got to connect")
	var trophy_id = trophie
	var already_has_trophy = false
	
	for trophy in trophies.get("trophies"):
		if str(trophy.id) == trophy_id:
			already_has_trophy = true
			break

	if already_has_trophy:
		print("Player already has the trophy: ", trophy_id)
	else:
		print("Awarding trophy: ", trophy_id)
		GameJolt.trophies_add_achieved(trophy_id)
