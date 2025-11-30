extends Node
class_name FadeManager

static var instance:FadeManager
@export var FadeColor:ColorRect

var FadeTween:Tween
var FadeValue:float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	pass # Replace with function body.


func FadeInColor(_time:float = 1.0,_color:Color = Color.BLACK):
	if FadeTween:
		FadeTween.kill()
	FadeTween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	FadeColor.color = _color
	FadeTween.tween_property(FadeColor,"color:a",0.0,_time)
	pass
func FadeOutColor(_time:float = 1.0,_color:Color = Color.BLACK):
	if FadeTween:
		FadeTween.kill()
	FadeTween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	FadeColor.color = _color
	FadeTween.tween_property(FadeColor,"color:a",1.0,_time)
	pass

func FlashFade(_time:float = 1.0,_color:Color = Color.BLACK):
	if FadeTween:
		FadeTween.kill()
	FadeTween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	FadeColor.color = _color
	FadeColor.color.a = 1.0
	FadeTween.tween_property(FadeColor,"color:a",0.0,_time)
	pass
