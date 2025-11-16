extends Control
class_name RoundControlOptions

@export var StartRoundButton:Control
@export var RoundControls:Control

@export var StartRoundButtonOpenArea:Vector2
@export var StartRoundButtonClosedArea:Vector2

@export var RoundControlsButtonOpenArea:Vector2
@export var RoundControlsButtonClosedArea:Vector2

var ControlsTween:Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ShowBeginRoundButton()
	pass # Replace with function body.


func ShowBeginRoundButton():
	if ControlsTween:
		ControlsTween.kill()
	ControlsTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	ControlsTween.parallel().tween_property(StartRoundButton,"position",StartRoundButtonOpenArea,1.0)
	ControlsTween.parallel().tween_property(RoundControls,"position",RoundControlsButtonClosedArea,1.0)
	pass

func BeginRoundButtonPressed():
	GameplayController.instance.BeginNewWave()
	
	if ControlsTween:
		ControlsTween.kill()
	ControlsTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	ControlsTween.parallel().tween_property(StartRoundButton,"position",StartRoundButtonClosedArea,1.0)
	ControlsTween.parallel().tween_property(RoundControls,"position",RoundControlsButtonOpenArea,1.0)
	pass
	
func SpeedupButtonPressed():
	GameplayController.instance.SetSpeedModifier(4.0)
	pass

func NormalSpeedButtonPressed():
	GameplayController.instance.SetSpeedModifier(1.0)
	pass

func PausedButtonPressed():
	GameplayController.instance.SetSpeedModifier(0.0)
	pass
