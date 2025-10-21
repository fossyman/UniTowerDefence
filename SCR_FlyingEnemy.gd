extends Enemy

@export var Pinpoint:Node3D

var SinT:float = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	SinT += delta
	Pinpoint.rotation_degrees = Vector3(sin(SinT * 5) * 1.5,cos(SinT * 2) * 5,cos(SinT * 2) * 1.5)

func Death():
	IsDead = true
	var Deathtween = get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	Hurtbox.set_deferred("monitorable",false)
	Hurtbox.set_deferred("monitoring",false)
	Deathtween.parallel().tween_property(MeshParent,"position:y",5,2)
	await Deathtween.finished
	GameplayController.instance.ActiveEnemies.erase(self)
	queue_free()
	pass
