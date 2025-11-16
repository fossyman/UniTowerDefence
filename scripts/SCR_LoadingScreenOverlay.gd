extends Control
class_name LoadingOverlay

@export var LoadingTipText:RichTextLabel
@export var LoadingBar:ProgressBar
@export var Scary:TextureRect
var LoadingProgress:float

func  _ready() -> void:
	var rand = randi_range(0,GLOBALS.LOADING_HINTS.size()-1)
	LoadingTipText.text = "[wave]" + str(GLOBALS.LOADING_HINTS[rand])
	if rand == 4:
		Scary.visible = true
func _process(delta: float) -> void:
	LoadingBar.value = lerp(LoadingBar.value,LoadingProgress,5*delta)
