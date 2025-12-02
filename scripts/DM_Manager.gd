extends Node
class_name DM_Manager

static var instance:DM_Manager

var NoGoldLines:Array[AudioStream]
var MaxLevelUpgradeLines:Array[AudioStream]
var FailLines:Array[AudioStream]
var WinLines:Array[AudioStream]
var AFKLines:Array[AudioStream]

var Lvl1To2IntroLines:Array[AudioStream]
var Lvl2To3IntroLines:Array[AudioStream]
var FinaleLines:Array[AudioStream]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	pass # Replace with function body.

func PlayAudio(_name:String):
	pass
