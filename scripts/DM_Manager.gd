extends Node
class_name DM_Manager

static var instance:DM_Manager

@export var AnimPlayer:AnimationPlayer
@export var Voicebox:AudioStreamPlayer
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

func PlayAudio(_sample:AudioStream,_volumedifference:float = 0.0):
	PlayVoiceline(_sample)
	pass
	
func PlayNoGoldLine():
	PlayVoiceline(NoGoldLines.pick_random())
	pass
func PlayMaxLevelUpgradeLine():
	PlayVoiceline(MaxLevelUpgradeLines.pick_random())
	pass
func PlayFailLine():
	PlayVoiceline(FailLines.pick_random())
	pass
func PlayWinLine():
	PlayVoiceline(WinLines.pick_random())
	pass
func PlayAFKLine():
	PlayVoiceline(AFKLines.pick_random())
	pass

func _input(event: InputEvent) -> void:
	if event is InputEvent:
		LastInteractionTime = 0.0

func PlayVoiceline(_line:AudioStream):
	Voicebox.stop()
	Voicebox.stream = _line
	Voicebox.play()
	pass
