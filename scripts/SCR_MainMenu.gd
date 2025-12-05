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
@export var CreditsScreen:Control
@export var BehindTheScenesScreen:Control
@export var BehindTheScenesImage:TextureRect
@export var BehindTheScenesDescription:RichTextLabel
@export var BehindTheScenesResources:Array[BTS_Image]
var CurrentBTSIDX:int = 0

@export var HowToPlayScreen:Control
@export var HowToPlayPics:Array[Control]
var HowToIDX:int = 0
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
			GLOBALS.GAMECOMPLETED = false
			SAVELOADMANAGER.SaveConfig()

func Play_Pressed():
	GLOBALS.ChangeRoot(GLOBALS.ROOT_GAMEPLAY)
	pass

func OptionsPressed():
	OptionsScreen.show()
	
func CloseOptionsMenu():
	OptionsScreen.hide()
	
func OpenCreditsScreen():
	CreditsScreen.show()
	pass

func CloseCreditsScreen():
	CreditsScreen.hide()
	pass

func OpenBehindTheScenesScreen():
	BehindTheScenesScreen.show()
	ProgressBTSImages(0)
	pass
func CloseBehindTheScenesScreen():
	BehindTheScenesScreen.hide()
	pass

func CloseAllMenus():
	CloseCreditsScreen()
	CloseBehindTheScenesScreen()
	CloseOptionsMenu()

func DecideStartingPerspective(_value:int):
	GLOBALS.PERSPECTIVE = _value
	FirstTimeSetupScreen.visible = false
	SAVELOADMANAGER.SaveConfig()

func QuitGame():
	get_tree().quit()

func ProgressBTSImages(_value:int = 1):
	CurrentBTSIDX += _value
	CurrentBTSIDX = clamp(CurrentBTSIDX,0,BehindTheScenesResources.size()-1)
	BehindTheScenesImage.texture = BehindTheScenesResources[CurrentBTSIDX].ReferenceImage
	BehindTheScenesDescription.text = BehindTheScenesResources[CurrentBTSIDX].Description

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


func HowTo_Pressed() -> void:
	AdvanceHowToScreen(0)
	HowToPlayScreen.visible = true
	pass # Replace with function body.

func CloseHowTo_Pressed() -> void:
	HowToPlayScreen.visible = false
	HowToIDX = 0
	pass # Replace with function body.


func AdvanceHowToScreen(extra_arg_0: int = 0) -> void:
	HowToIDX+=extra_arg_0
	HowToIDX = wrap(HowToIDX,0,HowToPlayPics.size())
	for i in HowToPlayPics.size():
		HowToPlayPics[i].visible = false
	HowToPlayPics[HowToIDX].visible = true
	
	pass # Replace with function body.
