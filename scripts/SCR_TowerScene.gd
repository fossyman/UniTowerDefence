extends Node3D
class_name TowerScene

var TowerResource:Tower

@export var ProjectileSpawnPoint:Node3D

@export var Tickrate:float = 1.0
var TickAmt:float

var _damage:float

var Target:Node3D

var TowerModifiers:Array[TowerModifier]

@export var LookAtTarget:bool = false

@export var LookAtNodes:Array[Node3D]

@export var TransparencyEnemy:Enemy

@export var Stats:Array[Stat]

@export var RangeDecal:Decal

@export var MeshParent:Node3D

@export var RealworldRep:Node3D

func _ready() -> void:
	CheckIfRealWorld()

func _process(delta: float) -> void:
	TickAmt += delta * GameplayController.instance.SpeedModifier
	if TickAmt > Tickrate:
		TickAmt = 0.0
		Tick()

func Tick():
	Target = Get_ClosestEnemy(true)
	if Target:
		if LookAtTarget:
			var targetlerp = get_tree().create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
			var diff = (Target.global_position - global_position)
			for i in LookAtNodes.size():
				targetlerp.tween_property(LookAtNodes[i],"rotation:y",atan2(diff.x,diff.z),0.5)
			await targetlerp.finished
		SpawnProjectile()

func SpawnProjectile():
	if !Target:
		return
		
	if TowerResource is DamageTower:
		var inst = TowerResource.ProjectileResource.Scene.instantiate() as ProjectileScene
		ProjectileSpawnPoint.add_child(inst)
		inst._Setup(TowerResource.ProjectileResource.Speed,GetCurrentAttackDamage())
		
		var dir = (Target.global_transform.origin - global_transform.origin)
		dir.y = 0
		dir = dir.normalized()
		var angle = atan2(-dir.x, -dir.z)
		inst.rotation.y = angle
	pass

func Get_ClosestEnemy(UseRadius:bool = false) -> Node3D:
	if GameplayController.instance.ActiveEnemies.is_empty():
		print("EMPTY")
		return null
	
	var Closest:Node3D = GameplayController.instance.ActiveEnemies[0]
	
	for i in GameplayController.instance.ActiveEnemies.size():
		var Distance:float = global_position.distance_to(GameplayController.instance.ActiveEnemies[i].global_position)
		if UseRadius:
			var RangeStatValue = GetCurrentAttackRange()
			if Distance < RangeStatValue:
				Closest = GameplayController.instance.ActiveEnemies[i]
				break
			else:
				Closest = null
		else:
			Closest = GameplayController.instance.ActiveEnemies[i]

	return Closest

func refreshStats():
	Tickrate = GetCurrentAttackSpeed()
	_damage = GetCurrentAttackDamage()

func ShowRangeDecal():
	RangeDecal.show()
	var range = GetCurrentAttackRange()
	RangeDecal.scale = Vector3(range,1.0,range)
	
func HideRangeDecal():
	RangeDecal.hide()


func GetCurrentAttackDamage() -> int:
	return Stats[0].GetAmount()
	pass
func GetCurrentAttackRange() -> float:
	return Stats[1].GetAmount()
	pass
func GetCurrentAttackSpeed() -> float:
	return Stats[2].GetAmount()
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
