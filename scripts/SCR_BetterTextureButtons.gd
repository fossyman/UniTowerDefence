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
	HoverTween.tween_property(self,"modulate",ClickColor,HoverTransitionTime)
	pass

func OnReleased():
	if HoverTween:
		HoverTween.kill()
	HoverTween = get_tree().create_tween()
	HoverTween.tween_property(self,"modulate",OriginalColour,HoverTransitionTime)
	pass

func OnHover():
	if HoverTween:
		HoverTween.kill()
	HoverTween = get_tree().create_tween()
	HoverTween.tween_property(self,"modulate",HoverColour,HoverTransitionTime)
	pass
	
func OnHoverExit():
	if HoverTween:
		HoverTween.kill()
	HoverTween = get_tree().create_tween()
	HoverTween.tween_property(self,"modulate",OriginalColour,HoverTransitionTime)
	pass
