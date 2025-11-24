extends Node3D

@export var AnimPlayer:AnimationPlayer

@export var StartAnim:String
@export var IdleAnim:String

var IdleTick:float = 3

func _ready() -> void:
	AnimPlayer.play(StartAnim)

func _process(delta: float) -> void:
	IdleTick -= delta
	if IdleTick <= 0:
		IdleTick = randf_range(3,15)
		#AnimPlayer.play(IdleAnim)
