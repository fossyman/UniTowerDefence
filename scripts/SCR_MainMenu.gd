extends Node

@export var FirstTimeSetupScreen:Control

@export var Env:WorldEnvironment

@export var PreWinMenu:Node3D
@export var PreWinCam:Camera3D
@export var PreWinEnv:Environment
@export var PostWinMenu:Node3D
@export var PostWinCam:Camera3D
@export var PostWinEnv:Environment

@export var OptionsScreen:CanvasLayer

func _ready() -> void:
	if FileAccess.file_exists(SAVELOADMANAGER.ConfigPath):
		FirstTimeSetupScreen.visible = false
		SAVELOADMANAGER.LoadConfig()
		
		SetStartingStage(GLOBALS.GAMECOMPLETED)
	else:
		FirstTimeSetupScreen.visible = true
		SetStartingStage(false)
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DEV_ClearSaveAndRestart"):
		if FileAccess.file_exists(SAVELOADMANAGER.ConfigPath):
			DirAccess.remove_absolute(SAVELOADMANAGER.ConfigPath)
			GLOBALS.ChangeRoot(GLOBALS.ROOT_MAINMENU)

func Play_Pressed():
	GLOBALS.ChangeRoot(GLOBALS.ROOT_GAMEPLAY)
	pass

func OptionsPressed():
	OptionsScreen.show()
	
func CloseOptionsMenu():
	OptionsScreen.hide()

func DecideStartingPerspective(_value:int):
	GLOBALS.PERSPECTIVE = _value
	FirstTimeSetupScreen.visible = false
	SAVELOADMANAGER.SaveConfig()

func SetStartingStage(_val:bool = false):
	if _val:
		PreWinMenu.visible = false
		PreWinMenu.process_mode = Node.NOTIFICATION_DISABLED
		PostWinMenu.visible = true
		PostWinMenu.process_mode = Node.PROCESS_MODE_INHERIT
		PreWinCam.current = false
		PostWinCam.current = true
		Env.environment = PostWinEnv
	else:
		PreWinMenu.visible = true
		PreWinMenu.process_mode = Node.PROCESS_MODE_INHERIT
		PostWinMenu.visible = false
		PostWinMenu.process_mode = Node.NOTIFICATION_DISABLED
		PreWinCam.current = true
		PostWinCam.current = false
		Env.environment = PreWinEnv
