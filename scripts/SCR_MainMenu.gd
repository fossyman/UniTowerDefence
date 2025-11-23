extends Node

@export var FirstTimeSetupScreen:Control

func _ready() -> void:
	if FileAccess.file_exists(SAVELOADMANAGER.ConfigPath):
		FirstTimeSetupScreen.visible = false
		SAVELOADMANAGER.LoadConfig()
	else:
		FirstTimeSetupScreen.visible = true
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DEV_ClearSaveAndRestart"):
		if FileAccess.file_exists(SAVELOADMANAGER.ConfigPath):
			DirAccess.remove_absolute(SAVELOADMANAGER.ConfigPath)
			GLOBALS.ChangeRoot(GLOBALS.ROOT_MAINMENU)

func Play_Pressed():
	GLOBALS.ChangeRoot(GLOBALS.ROOT_GAMEPLAY)
	pass


func DecideStartingPerspective(_value:int):
	GLOBALS.PERSPECTIVE = _value
	FirstTimeSetupScreen.visible = false
	SAVELOADMANAGER.SaveConfig()
