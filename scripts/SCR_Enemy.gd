extends PathFollow3D
class_name Enemy

@export var Damage:int = 1
@export var TravelSpeed:float = 1.0
var CurrentTravelSpeed = 1.0
var dir:Vector3
var PosCache:Vector3
@export var MeshParent:Node3D
@export var HealthComp:COMPONENT_HEALTH
var IsDead:bool = false
@export var Hurtbox:HurtboxComponent
@export var AnimPlayer:AnimationPlayer
var Deathtween:Tween

@export var CurrentStatusEffect:StatusEffect
var StatusVisual:Node3D
var StatusTick = 1.0
var CurrentStatusTick:float = 1.0
var StatusLifetime = 1.0

@export var SpawnSFX:Array[AudioStream]

@export var DeathReward:int = 1

@export var RealworldRep:Node3D

func _ready() -> void:
	CurrentTravelSpeed = TravelSpeed
	CheckIfRealWorld()
	HealthComp.HealthCap += GameplayController.instance.WaveIDX
	HealthComp.SetHealth(HealthComp.HealthCap)
	if !SpawnSFX.is_empty():
		AUDIOMANAGER.PlaySFX(SpawnSFX.pick_random(),0.1,0.0,&"RadioSFX")
	
	ChangeAnimSpeed()
	
func _process(delta: float) -> void:
	if IsDead:
		return
	if CurrentStatusEffect:
		CurrentStatusTick -= delta
		StatusLifetime -= delta
		if CurrentStatusTick <= 0:
			CheckStatusEffects()
			CurrentStatusTick = StatusTick
		if StatusLifetime <= 0:
			ClearStatusEffect()
		
	if !IsDead && progress_ratio < 1.0:
		PosCache = global_position
		progress_ratio += CurrentTravelSpeed * GameplayController.instance.SpeedModifier * delta
		dir = (PosCache - global_position).normalized()
		if RealworldRep and dir != Vector3.ZERO:
			RealworldRep.rotation.y = atan2(dir.x,dir.z)
	if progress_ratio >= 1.0:
		Death(false,true)
		print("END REACHED")
	pass

func Death(_AddGold:bool = true, AtEnd:bool = false):
	if _AddGold:
		GameplayController.instance.AddGold(randi_range(DeathReward,DeathReward+5) + GameplayController.instance.MapIDX + GameplayController.instance.WaveIDX)
	if !AtEnd:
		GameplayController.instance.STATS_Kills += 1
	else:
		GameplayController.instance.SubtractHealth(Damage)
		
	IsDead = true
	DeathEffect()
	Hurtbox.set_deferred("monitorable",false)
	Hurtbox.set_deferred("monitoring",false)
	GameplayController.instance.ActiveEnemies.erase(self)
	GameplayController.instance.CheckWaveCompletion()
	if Deathtween:
		await Deathtween.finished
	queue_free()
	pass
func DeathEffect():
	if GameplayController.instance.FullFantasy:
		if RealworldRep:
			RealworldRep.visible = false
		pass
	else:
		Deathtween = get_tree().create_tween()
		if dir.x > 0.9 || dir.x < -0.9:
			#LEFT
			Deathtween.parallel().tween_property(MeshParent,"rotation_degrees",Vector3(0,0,0),0.3)
			Deathtween.parallel().tween_property(MeshParent,"position:y",-5,1)
			pass
		elif dir.z > 0.9 || dir.z < -0.9:
			#UP
			Deathtween.tween_property(MeshParent,"rotation_degrees",Vector3(0,90,0),0.3)
			Deathtween.tween_property(MeshParent,"position:y",-5,1)
			pass
		else:
			Deathtween.tween_property(MeshParent,"rotation_degrees",Vector3(0,0,0),0.3)
			Deathtween.tween_property(MeshParent,"position:y",-5,1)
		await Deathtween.finished

func CheckStatusEffects():
	if CurrentStatusEffect.StatusType == StatusEffect.STATUSTYPE.DAMAGE:
		HealthComp.Damage(CurrentStatusEffect.StatusPower)
	if CurrentStatusEffect.StatusType == StatusEffect.STATUSTYPE.FREEZE:
		CurrentTravelSpeed = 0.0
		print("FREEZE")

func ApplyStatusEffect(_effect:StatusEffect):
	CurrentStatusEffect = _effect
	StatusTick = _effect.TickTime
	CurrentStatusTick = StatusTick
	StatusLifetime = _effect.StatusLifetime
	if _effect.StatusVisual:
		var vis = _effect.StatusVisual.instantiate()
		add_child(vis)
		StatusVisual = vis
	CheckStatusEffects()
	pass
	
func ClearStatusEffect():
	if  CurrentStatusEffect.StatusType == StatusEffect.STATUSTYPE.FREEZE:
		CurrentTravelSpeed = TravelSpeed
	CurrentStatusEffect = null
	if StatusVisual:
		StatusVisual.queue_free()
	pass

func CheckIfRealWorld():
	if GameplayController.instance.FullFantasy:
		if RealworldRep:
			RealworldRep.visible = true
			MeshParent.visible = false
	else:
		if RealworldRep:
			RealworldRep.visible = false
		MeshParent.visible = true

func ChangeAnimSpeed(_value = GameplayController.instance.SpeedModifier):
	if AnimPlayer:
		AnimPlayer.speed_scale = _value
