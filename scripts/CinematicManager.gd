extends Node
class_name CinematicManager
var AnimTimer:Timer

@export var KingAnimPlayer:AnimationPlayer
@export var DarkLordAnimPlayer:AnimationPlayer

@export var AttackNames=["ATT1","ATT2","ATT3"]

@export var ImpactSFXs:Array[AudioStream]

@export var ImpactSprite:Sprite3D
var ImpactSpriteTween:Tween

@export var FightRoot:TEST_ROTATOR

func _ready() -> void:
	AnimTimer = Timer.new()
	add_child(AnimTimer)
	AnimTimer.one_shot = true
	AnimTimer.connect("timeout",SwitchAnim)
	AnimTimer.start()
	pass

func SwitchAnim():
	AnimTimer.stop()
	var idx = randi_range(0,2)
	var kinganim =KingAnimPlayer.get_animation(AttackNames[idx])
	var DLAnim = DarkLordAnimPlayer.get_animation(AttackNames[idx])
	KingAnimPlayer.play(AttackNames[idx])
	DarkLordAnimPlayer.play(AttackNames[idx])
	var waittime = kinganim.length if kinganim.length > DLAnim.length else DLAnim.length
	AnimTimer.wait_time = 1.7
	AnimTimer.start()
	print("NEW WAITTIME: " + str(waittime))
	pass

func PlayKillAnim():
	AnimTimer.stop()
	DM_Manager.instance.PlayAudio(DM_Manager.instance.LevelSpecificLines[2])
	var FinisherTween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	FightRoot.RotateSpeedY = 0.0
	FightRoot.RotateSpeedX = 0.0
	FinisherTween.tween_property(FightRoot,"rotation_degrees:y",0.0,1.0)
	GameplayController.instance.SmoothZoomCamera(30)
	GameplayController.instance.CameraFocusPoint = ImpactSprite
	await FinisherTween.finished
	KingAnimPlayer.play("FINALE")
	DarkLordAnimPlayer.play("FINALE")
	await get_tree().create_timer(6.0).timeout
	KillAnimFinished()
	
func KillAnimFinished():
	GameplayController.instance.DisplayVictoryScreen()
	pass

func Impact():
	var SFX = ImpactSFXs.pick_random()
	AUDIOMANAGER.PlaySFX(SFX,0.3,-24)
	ImpactSprite.modulate.a = 1.0
	if ImpactSpriteTween:
		ImpactSpriteTween.kill()
	ImpactSpriteTween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	ImpactSpriteTween.tween_property(ImpactSprite,"modulate:a",0.0,2.0)
