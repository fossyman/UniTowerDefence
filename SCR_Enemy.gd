extends PathFollow3D
class_name Enemy

@export var TravelSpeed:float = 1.0
var dir:Vector3
var PosCache:Vector3
@export var MeshParent:Node3D
@export var HealthComp:COMPONENT_HEALTH
var IsDead:bool = false
@export var Hurtbox:HurtboxComponent

func _process(delta: float) -> void:
	if !IsDead:
		PosCache = global_position
		progress_ratio += TravelSpeed * delta
		dir = (PosCache - global_position).normalized()
	if Input.is_action_just_pressed("ui_accept"):
		Death()
	pass

func Death():
	IsDead = true
	var Deathtween = get_tree().create_tween()
	Hurtbox.set_deferred("monitorable",false)
	Hurtbox.set_deferred("monitoring",false)
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
	GameplayController.instance.ActiveEnemies.erase(self)
	GameplayController.instance.CheckWaveCompletion()
	queue_free()
	pass
