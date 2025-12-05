extends Control

var IsPaused:bool

var IsOptionsMenuOpen:bool

@export var PauseLayer:CanvasLayer
@export var OptionsLayer:CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ResumeGame():
	TogglePauseMenu()
	pass

func TogglePauseMenu(_specific:bool = !IsPaused):
	IsPaused = _specific
	get_tree().paused = IsPaused
	visible = IsPaused
	PauseLayer.visible = IsPaused
	ToggleOptionsMenu()
	pass
	
func ToggleOptionsMenu(_value:bool = false):
	IsOptionsMenuOpen = _value
	OptionsLayer.visible = IsOptionsMenuOpen
	pass
	
func Quit():
	TogglePauseMenu(false)
	GLOBALS.ChangeRoot(GLOBALS.ROOT_MAINMENU)
	pass
