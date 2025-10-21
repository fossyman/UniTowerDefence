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

@export_flags_3d_physics var ENEMY_COLLISION_LAYER:int

enum MOUSESTATES{PLAYING,PLACING}

var MouseState:MOUSESTATES = MOUSESTATES.PLAYING

var PlacingTower:Tower

var ValidPlacement:bool = false

var SelectedTower:TowerScene

@export var SpawnTickrate:float
var CurrentSpawnTickrate:float

@export var Gold:int = 0

@export_flags_3d_physics var COLLISIONMASK:int

@export var WaveIDX:int
var WaveFinished:bool = false

@export var WaveResources:Array[Wave]
var EnemyCount:int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	DEVTOOLS_PROCESS()
	if !WaveFinished:
		CurrentSpawnTickrate += delta
		if CurrentSpawnTickrate >= SpawnTickrate:
			if EnemyCount < WaveResources[WaveIDX].EnemyCapacity:
				SpawnEnemy(WaveResources[WaveIDX].GetNextEnemy())
			CurrentSpawnTickrate = 0
	
	if Input.is_action_just_pressed("ui_accept"):
		WaveIDX+=1
		WaveIDX = wrap(WaveIDX,0,WaveResources.size())
		EnemyCount = 0
		WaveFinished = false
		
	
	match(MouseState):
		MOUSESTATES.PLAYING:
			if Input.is_action_just_pressed("click"):
				var result = RaycastToFloor()
				if result:
					match (result["collider"].collision_layer):
						8: # UpgradeAreaCollision
							SelectedTower = (result["collider"].get_parent() as TowerScene)
							UpgradeScreen.populateSettings(SelectedTower)
							
							pass
		MOUSESTATES.PLACING:
			var result = RaycastToFloor()
			if result && result["normal"] == Vector3.UP:
				PlacementDecal.global_position = result["position"]
				ValidPlacement = true
			else:
				ValidPlacement = false
			PlacementDecal.visible = ValidPlacement
			if Input.is_action_just_pressed("click"):
				if ValidPlacement:
					var TowerScn = PlacingTower.TowerScn.instantiate() as TowerScene
					for i in TowerScn.TowerResource.Stats.size():
						var stat = TowerScn.Stats[i] as Stat
						#TowerScn.Stats.append( Stat.new(stat.Name,stat.Icon,stat.Amount,stat.Level,stat.Cost) )
					add_child(TowerScn)
					TowerScn.global_position = result["position"]
					MouseState = MOUSESTATES.PLAYING
					PlacementDecal.visible = false
					pass
			pass
	pass

func RaycastToFloor() -> Dictionary:
	#Raycasting learned by Godot Docs
	var space_state = get_tree().root.world_3d.direct_space_state
	var query = PhysicsRayQueryParameters3D.create(MainCamera.global_position, MainCamera.project_position(get_viewport().get_mouse_position(),999),COLLISIONMASK)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	
	return result

func BeginNewWave():
	WaveIDX+=1
	

func SpawnEnemy(_enemy:PackedScene):
	var EnemyInst = _enemy.instantiate()
	EnemyCount+=1
	MapPath.add_child(EnemyInst)
	ActiveEnemies.append(EnemyInst)
	EnemyInst.progress_ratio = 0

func CheckWaveCompletion():
	if EnemyCount >= WaveResources[WaveIDX].EnemyCapacity and ActiveEnemies.is_empty():
		WaveFinished = true
		print("WAVE COMPLETED")
	pass

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
