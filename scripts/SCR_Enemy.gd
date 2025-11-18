extends PathFollow3D
class_name Enemy

@export var TravelSpeed:float = 1.0
var dir:Vector3
var PosCache:Vector3
@export var MeshParent:Node3D
@export var HealthComp:COMPONENT_HEALTH
var IsDead:bool = false
@export var Hurtbox:HurtboxComponent

var Deathtween:Tween

@export var CurrentStatusEffect:StatusEffect
var StatusVisual:Node3D
var StatusTick = 1.0
var CurrentStatusTick:float = 1.0
var StatusLifetime = 1.0
func _process(delta: float) -> void:
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
		progress_ratio += TravelSpeed * GameplayController.instance.SpeedModifier * delta
		dir = (PosCache - global_position).normalized()
	if progress_ratio >= 1.0:
		Death(false)
		print("END REACHED")
	pass

func Death(_AddGold:bool = true):
	if _AddGold:
		GameplayController.instance.AddGold(1)
	IsDead = true
	DeathEffect()
	Hurtbox.set_deferred("monitorable",false)
	Hurtbox.set_deferred("monitoring",false)
	await Deathtween.finished
	GameplayController.instance.ActiveEnemies.erase(self)
	GameplayController.instance.CheckWaveCompletion()
	queue_free()
	pass
func DeathEffect():
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

func ApplyStatusEffect(_effect:StatusEffect):
	CurrentStatusEffect = _effect
	StatusTick = _effect.TickTime
	CurrentStatusTick = StatusTick
	StatusLifetime = _effect.StatusLifetime
	var vis = _effect.StatusVisual.instantiate()
	add_child(vis)
	StatusVisual = vis
	pass
func ClearStatusEffect():
	CurrentStatusEffect = null
	StatusVisual.queue_free()
	pass
