extends Node

var AnimTimer:Timer

@export var KingAnimPlayer:AnimationPlayer
@export var DarkLordAnimPlayer:AnimationPlayer

func _ready() -> void:
	AnimTimer = Timer.new()
	add_child(AnimTimer)
	AnimTimer.one_shot = false
	AnimTimer.connect("timeout",SwitchAnim)
	AnimTimer.start()
	pass

func SwitchAnim():
	var idx = randi_range(0,4)
	var kinganim =KingAnimPlayer.get_animation_list()[idx]
	var DLAnim = DarkLordAnimPlayer.get_animation_list()[idx]
	KingAnimPlayer.play(kinganim)
	DarkLordAnimPlayer.play(DLAnim)
	var waittime = kinganim.length() if kinganim.length() > DLAnim.length() else DLAnim.length()
	AnimTimer.wait_time = waittime
	pass
