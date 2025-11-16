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

func _process(delta: float) -> void:
	if !IsDead && progress_ratio < 1.0:
		PosCache = global_position
		progress_ratio += TravelSpeed * GameplayController.instance.SpeedModifier * delta
		dir = (PosCache - global_position).normalized()
	if progress_ratio >= 0.92:
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
