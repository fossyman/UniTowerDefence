extends Node
class_name DM_Manager

static var instance:DM_Manager

@export var AnimPlayer:AnimationPlayer

@export var LevelSpecificLines:Array[AudioStream]
@export var NoGoldLines:Array[AudioStream]
@export var MaxLevelUpgradeLines:Array[AudioStream]
@export var FailLines:Array[AudioStream]
@export var WinLines:Array[AudioStream]
@export var AFKLines:Array[AudioStream]

var Lvl1To2IntroLines:Array[AudioStream]
var Lvl2To3IntroLines:Array[AudioStream]
var FinaleLines:Array[AudioStream]

var LastInteractionTime:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	if GameplayController.instance.Roundstate != GameplayController.ROUNDSTATES.ONGOING:
		LastInteractionTime += delta
		if LastInteractionTime >= 20:
			PlayAFKLine()
			LastInteractionTime = 0

func PlayAudio(_sample:AudioStream):
	AUDIOMANAGER.PlaySFX(_sample,0.0,0.0,&"VOICE")
	pass
	
func PlayNoGoldLine():
	AUDIOMANAGER.PlaySFX(NoGoldLines.pick_random(),0.0,0.0,&"VOICE")
	pass
func PlayMaxLevelUpgradeLine():
	AUDIOMANAGER.PlaySFX(MaxLevelUpgradeLines.pick_random(),0.0,0.0,&"VOICE")
	pass
func PlayFailLine():
	AUDIOMANAGER.PlaySFX(FailLines.pick_random(),0.0,0.0,&"VOICE")
	pass
func PlayWinLine():
	AUDIOMANAGER.PlaySFX(WinLines.pick_random(),0.0,0.0,&"VOICE")
	pass
func PlayAFKLine():
	AUDIOMANAGER.PlaySFX(AFKLines.pick_random(),0.0,0.0,&"VOICE")
	pass

func _input(event: InputEvent) -> void:
	if event is InputEvent:
		LastInteractionTime = 0.0
