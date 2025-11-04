extends Control
class_name LoadingOverlay

@export var LoadingTipText:RichTextLabel
@export var LoadingBar:ProgressBar
var LoadingProgress:float

func  _ready() -> void:
	LoadingTipText.text = "[wave]" + str(GLOBALS.LOADING_HINTS.pick_random())

func _process(delta: float) -> void:
	LoadingBar.value = lerp(LoadingBar.value,LoadingProgress,5*delta)
