@tool
extends TextureButton
class_name BetterTextureButton

@export var OriginalColour:Color
@export var HoverColour:Color
@export var ClickColor:Color
@export var HoverTransitionTime:float = 1.0
var HoverTween:Tween

func _ready() -> void:
	connect("button_down",OnPressed)
	connect("button_up",OnReleased)
	connect("mouse_entered",OnHover)
	connect("mouse_exited",OnHoverExit)
	OriginalColour = modulate
	pass

func OnPressed():
	
	if HoverTween:
		HoverTween.kill()
	HoverTween = get_tree().create_tween()
	HoverTween.tween_property(self,"self_modulate",ClickColor,HoverTransitionTime)
	pass

func OnReleased():
	if !toggle_mode:
		FadeToColor(OriginalColour)
	pass

func OnHover():
	if !toggle_mode:
		FadeToColor(HoverColour)
	pass
	
func OnHoverExit():
	if !toggle_mode:
		FadeToColor(OriginalColour)
	pass

func FadeToColor(_to:Color,_time:float = HoverTransitionTime):
	if HoverTween:
		HoverTween.kill()
	HoverTween = get_tree().create_tween()
	HoverTween.tween_property(self,"self_modulate",_to,_time)
	pass
