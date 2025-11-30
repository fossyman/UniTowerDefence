extends Node

var ConfigPath = "user://savegame.conf"

func SaveConfig():
	var save_file = FileAccess.open(ConfigPath, FileAccess.WRITE)
	save_file.store_var(GLOBALS.PERSPECTIVE)
	save_file.store_var(GLOBALS.GAMECOMPLETED)
func LoadConfig():
	if FileAccess.file_exists(ConfigPath):
		print("file found")
		var file = FileAccess.open(ConfigPath, FileAccess.READ)
		GLOBALS.PERSPECTIVE = file.get_var()
		GLOBALS.GAMECOMPLETED = file.get_var()
	else:
		print("file not found")
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LoadConfig()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
