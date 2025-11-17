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

@export var MapHolder:Node3D

@export var TowerHolder:Node3D

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

@export var CurrentMap:RES_Map

@export var WaveIDX:int = -1
var WaveFinished:bool = false

var EnemyCount:int = 0

var SpeedModifier:float = 1.0

enum ROUNDSTATES{PREROUND,ONGOING}
@export var Roundstate:ROUNDSTATES = ROUNDSTATES.PREROUND

@export var CinematicNode:Node3D
@export var CinematicCameraNode:Node3D
var CinematicMode:bool = false
var CinematicSpeed:float = -0.003

@export var RoundControls:RoundControlOptions

@export var DMAnimPlayer:AnimationPlayer
@export var TableAnimPlayer:AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	#await get_tree().create_timer(3.0).timeout
	#ToggleCinematicMode(true)
	GoldText.text = str("%.2f" % Gold)                                                                                                                                                                                                                                                           
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	DEVTOOLS_PROCESS()
	if Input.is_action_just_pressed("ui_accept"):
		SwapLevel(ResourceLoader.load(GLOBALS.MAPS[1]))
	if CinematicMode:
		CinematicNode.rotate_y(CinematicSpeed)
	
	
	if Roundstate == ROUNDSTATES.ONGOING && !WaveFinished:
		CurrentSpawnTickrate += delta * SpeedModifier
		if CurrentSpawnTickrate >= CurrentMap.WaveResources[WaveIDX].SpawnSpeed:
			if EnemyCount < CurrentMap.WaveResources[WaveIDX].EnemyCapacity:
				SpawnEnemy(CurrentMap.WaveResources[WaveIDX].GetNextEnemy())
				print("SPAWNING ENEMY")
			CurrentSpawnTickrate = 0
	
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
			if PlacementDecal.has_overlapping_areas():
				ValidPlacement = false 
			
			PlacementDecal.visible = ValidPlacement
			if Input.is_action_just_pressed("click"):
				if ValidPlacement:
					var TowerScn = PlacingTower.TowerScn.instantiate() as TowerScene
					print(TowerScn)
					for i in PlacingTower.Stats.size():
						#PlacingTower.Stats[i] as
						var stat:Stat = Stat.new()
						stat._Setup(PlacingTower.Stats[i].Name,PlacingTower.Stats[i].Icon,PlacingTower.Stats[i].Amount,PlacingTower.Stats[i].Level,PlacingTower.Stats[i].Cost)
						TowerScn.Stats.append(stat)
					TowerScn.TowerResource = PlacingTower
					TowerHolder.add_child(TowerScn)
					TowerScn.global_position = result["position"]
					MouseState = MOUSESTATES.PLAYING
					PlacementDecal.visible = false
					GameplayController.instance.SubtractGold(PlacingTower.Price)
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
	print("STARTING NEW WAVE")
	WaveIDX+=1
	EnemyCount = 0
	WaveFinished = false
	Roundstate = ROUNDSTATES.ONGOING

func SpawnEnemy(_enemy:PackedScene):
	var EnemyInst = _enemy.instantiate()
	EnemyCount+=1
	MapPath.add_child(EnemyInst)
	ActiveEnemies.append(EnemyInst)
	EnemyInst.progress_ratio = 0

func CheckWaveCompletion():
	if EnemyCount >= CurrentMap.WaveResources[WaveIDX].EnemyCapacity and ActiveEnemies.is_empty():
		WaveFinished = true
		Roundstate = ROUNDSTATES.PREROUND
		RoundControls.ShowBeginRoundButton()
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

func ToggleCinematicMode(value:bool,Lerptime:float = 4.0):
	CinematicMode = value
	if CinematicMode:
		var T = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		T.parallel().tween_property(CinematicCameraNode,"rotation_degrees:x",35,Lerptime)
		T.parallel().tween_property(CinematicCameraNode,"position:y",3,Lerptime)
	else:
		var T = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		T.parallel().tween_property(CinematicCameraNode,"rotation_degrees:x",0,Lerptime)
		T.parallel().tween_property(CinematicCameraNode,"position:y",0,Lerptime)
	pass

func SetSpeedModifier(_value:float):
	SpeedModifier = _value


func SwapLevel(_NewLevel:RES_Map):
	CurrentMap = _NewLevel
	DMAnimPlayer.play("swap")
	TableAnimPlayer.play("swap")
	await get_tree().create_timer(2.0).timeout
	for i in TowerHolder.get_child_count():
		TowerHolder.get_child(i).queue_free()
	var NewMap = _NewLevel.MapScene.instantiate()
	MapHolder.get_child(0).queue_free()
	MapHolder.add_child(NewMap)
	MapPath = NewMap.find_child("PATH",true,false)
