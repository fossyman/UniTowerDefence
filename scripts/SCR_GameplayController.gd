extends Node
class_name GameplayController

static var instance:GameplayController

@export var MainCamera:Camera3D

@export var PlacementDecal:Area3D

@export var GoldText:RichTextLabel

@export var UpgradeScreen:UpgradeAreaManager

@export var TowerPurchaseScreen:TowerPurchaseMenu

@export var ActiveEnemies:Array[Node3D]

@export var MapPath:Path3D

enum MOUSESTATES{PLAYING,PLACING}

var MouseState:MOUSESTATES = MOUSESTATES.PLAYING

var PlacingTower:Tower

var ValidPlacement:bool = false

var SelectedTower:TowerScene

@export var Enemies:Array[PackedScene]

@export var SpawnTickrate:float
var CurrentSpawnTickrate:float

@export var Gold:int = 0

@export_flags_3d_physics var COLLISIONMASK:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	DEVTOOLS_PROCESS()
	CurrentSpawnTickrate += delta
	if CurrentSpawnTickrate >= SpawnTickrate:
		SpawnEnemy()
		CurrentSpawnTickrate = 0
	
	
	match(MouseState):
		MOUSESTATES.PLAYING:
			if Input.is_action_just_pressed("click"):
				var result = RaycastToFloor()
				if result:
					print(result["normal"] == Vector3.UP)
					print((result["collider"] as Area3D).get_parent().name)
					match (result["collider"].collision_layer):
						8: # UpgradeAreaCollision
							SelectedTower = (result["collider"].get_parent() as TowerScene)
							UpgradeScreen.populateSettings(SelectedTower)
							
							pass
		MOUSESTATES.PLACING:
			var result = RaycastToFloor()
			if result && result["normal"] == Vector3.UP:
				PlacementDecal.global_position = result["position"]
				PlacementDecal.visible = !PlacementDecal.has_overlapping_areas()
				ValidPlacement = true
			else:
				ValidPlacement = false
			if Input.is_action_just_pressed("click"):
				if ValidPlacement:
					var TowerScn = PlacingTower.TowerScn.instantiate() as TowerScene
					TowerScn.TowerResource = PlacingTower
					add_child(TowerScn)
					TowerScn.global_position = result["position"]
					MouseState = MOUSESTATES.PLAYING
					PlacementDecal.visible = false
					pass
			pass
	print(ValidPlacement)
	pass

func RaycastToFloor() -> Dictionary:
	#Raycasting learned by Godot Docs
	var space_state = get_tree().root.world_3d.direct_space_state
	var query = PhysicsRayQueryParameters3D.create(MainCamera.global_position, MainCamera.project_position(get_viewport().get_mouse_position(),999),COLLISIONMASK)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	
	return result

func SpawnEnemy():
	var Enemy = Enemies[0].instantiate()

	MapPath.add_child(Enemy)
	ActiveEnemies.append(Enemy)
	Enemy.progress_ratio = 0

func DEVTOOLS_PROCESS():
	if Input.is_action_just_pressed("DEV_SpeedTime"):
		Engine.time_scale+=1
	elif Input.is_action_just_pressed("DEV_SlowTime"):
		Engine.time_scale-=1
	pass

func AddGold(_amount:int):
	Gold += _amount
	GoldText.text = str("%.2f" % Gold)
	pass
func SubtractGold(_amount:int):
	Gold -= _amount
	GoldText.text = str("%.2f" % Gold)
	pass
func SetGold(_amount:int):
	Gold = _amount
	GoldText.text = str("%.2f" % Gold)
	pass
