extends Node
class_name GameplayController

static var instance:GameplayController

@export var MainCamera:Camera3D
var CameraFocusPoint:Node3D
@export var PlacementArea:Area3D
@export var PlacementDecal:Decal
@export var PlacementAttackRangeDecal:Decal
@export var PlacementCollisionChecker:CollisionShape3D

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

@export var SpawnTickrate:float
var CurrentSpawnTickrate:float

@export var Gold:int = 0

@export var Health:int = 100
@export var HealthLabel:RichTextLabel

@export_flags_3d_physics var GAMEPLAYCOLLISIONMASK:int
@export_flags_3d_physics var PLACEMENTCOLLISIONMASK:int
@onready var CurrentCollisionMask = GAMEPLAYCOLLISIONMASK

@export var MAPS:Array[RES_Map]
@export var CurrentMap:RES_Map
var MapIDX = 0

@export var WaveIDX:int = -1
var WaveFinished:bool = false

var EnemyCount:int = 0

var SpeedModifier:float = 1.0

enum ROUNDSTATES{PREROUND,ONGOING,END}
@export var Roundstate:ROUNDSTATES = ROUNDSTATES.PREROUND
@export var RoundLabel:RichTextLabel

@export var CinematicNode:CinematicManager
@export var CinematicCameraNode:Node3D
var CinematicMode:bool = false
var CinematicSpeed:float = -0.003

@export var RoundControls:RoundControlOptions

@export var DMAnimTree:AnimationTree
@export var TableAnimPlayer:AnimationPlayer

@export var VictoryScreen:Control
@export var VictoryStatsText:RichTextLabel

@export var FailScreen:Control

var TimeTick:float = 1.0
var STATS_Time:int = 0
var STATS_GoldSpent:int = 0
var STATS_Kills:int = 0

var FullFantasy:bool = true
@export var FullFantasyBoard:Node3D
@export var DefaultMapBoard:Node3D

@export var FinalFightSong:AudioStream
@export var FinalFightSongTransitionPoint:float = 2.0
@export var LightningSFX:AudioStream
@export var RainSFX:AudioStreamPlayer

func StartFantasyTransition():
	MUSICMANAGER.PickNewSong(FinalFightSong)
	await get_tree().create_timer(FinalFightSongTransitionPoint).timeout
	FadeManager.instance.FlashFade(8.0,Color.WHITE)
	SwapFantasyMode(true)
	AUDIOMANAGER.PlaySFX(LightningSFX,0,-10)

func SwapFantasyMode(_Fantasy:bool = true,_lightning:bool = false):
	if _lightning:
		FadeManager.instance.FlashFade(8.0,Color.WHITE)
		AUDIOMANAGER.PlaySFX(LightningSFX,0,-10)
	if _Fantasy:
		FullFantasyBoard.visible = true
		FullFantasyBoard.process_mode = Node.PROCESS_MODE_INHERIT
		DefaultMapBoard.visible = false
		DefaultMapBoard.process_mode = Node.PROCESS_MODE_DISABLED
		RainSFX.play()
		FullFantasy = true
	else:
		MUSICMANAGER.MusicPlayer.stop()
		FullFantasyBoard.visible = false
		FullFantasyBoard.process_mode = Node.PROCESS_MODE_DISABLED
		DefaultMapBoard.visible = true
		DefaultMapBoard.process_mode = Node.PROCESS_MODE_INHERIT
		RainSFX.stop()
		FullFantasy = false
		
	for i in ActiveEnemies.size():
		ActiveEnemies[i].CheckIfRealWorld()
	for i in TowerHolder.get_child_count():
		TowerHolder.get_child(i).CheckIfRealWorld()




func _ready() -> void:
	instance = self
	SwapFantasyMode(false)
	#await get_tree().create_timer(3.0).timeout
	#ToggleCinematicMode(true)
	GoldText.text = str("%.2f" % Gold)
	RoundLabel.text = "Round 1" + "/" + str(CurrentMap.WaveResources.size())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	TimeTick -= delta
	if TimeTick <= 0:
		TimeTick = 1.0
		STATS_Time += 1
	
	if CameraFocusPoint:
		MainCamera.look_at(CameraFocusPoint.global_position)
	if GLOBALS.DEVMODE:
		DEVTOOLS_PROCESS()
	if CinematicMode:
		CinematicNode.rotate_y(CinematicSpeed)
	
	if Input.is_action_just_pressed("SwitchPerspective"):
		SwitchPerspective()
	
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
				print("RAYCASTING")
				if result:
					match (result["collider"].collision_layer):
						8: # UpgradeAreaCollision
							if UpgradeScreen.OpenTween:
								UpgradeScreen.OpenTween.kill()
								
							print("UPGRADER HIT")
							var SelectedTower = (result["collider"].get_parent() as TowerScene)
							if !UpgradeScreen.SelectedTower and !UpgradeScreen.SelectedTowerScene:
								UpgradeScreen.populateSettings(SelectedTower)
							else:
								print("selected tower")
								if UpgradeScreen.SelectedTowerScene == SelectedTower:
									UpgradeScreen.CloseMenu(0.1)
								else:
									UpgradeScreen.CloseMenu(0.1)
									if UpgradeScreen.OpenTween:
										await UpgradeScreen.OpenTween.finished
									print(UpgradeScreen.OpenTween)
									UpgradeScreen.populateSettings(SelectedTower)
		MOUSESTATES.PLACING:
			var result = RaycastToFloor()
			
			if result:
				PlacementArea.global_position = result["position"]

			if result && result["normal"] == Vector3.UP:
				ValidPlacement = true
			else:
				ValidPlacement = false
			if PlacementArea.has_overlapping_areas():
				ValidPlacement = false 
				
			if ValidPlacement:
				PlacementDecal.modulate = Color.WHITE
			else:
				PlacementDecal.modulate = Color.RED
				
			if Input.is_action_just_pressed("click"):
				if ValidPlacement:
					var TowerScn = PlacingTower.TowerScn.instantiate() as TowerScene
					print(TowerScn)
					for i in PlacingTower.Stats.size():
						var stat:Stat = Stat.new()
						stat._Setup(PlacingTower.Stats[i].Name,PlacingTower.Stats[i].Icon,PlacingTower.Stats[i].Amount,PlacingTower.Stats[i].Level,PlacingTower.Stats[i].Cost)
						TowerScn.Stats.append(stat)
					TowerScn.TowerResource = PlacingTower
					TowerHolder.add_child(TowerScn)
					TowerScn.global_position = result["position"]
					MouseState = MOUSESTATES.PLAYING
					PlacementArea.visible = false
					GameplayController.instance.SubtractGold(PlacingTower.Price)
					AUDIOMANAGER.PlaySFX(AUDIOMANAGER.BUY_SFX)
					CurrentCollisionMask = GAMEPLAYCOLLISIONMASK
					TowerPurchaseMenu.instance.ToggleStopTowerPlacement()
				else:
					#StopPlacingTower()
					#TowerPurchaseMenu.instance.ToggleStopTowerPlacement()
					pass
				UpgradeScreen.DeselectTower()
			pass
	pass

func RaycastToFloor() -> Dictionary:
	#Raycasting learned by Godot Docs
	var space_state = get_tree().root.world_3d.direct_space_state
	var query = PhysicsRayQueryParameters3D.create(MainCamera.global_position, MainCamera.project_position(get_viewport().get_mouse_position(),999),CurrentCollisionMask)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	
	return result

func BeginNewWave():
	print("STARTING NEW WAVE")
	WaveIDX+=1
	EnemyCount = 0
	WaveFinished = false
	Roundstate = ROUNDSTATES.ONGOING
	RoundLabel.text = "Round " + str(WaveIDX+1) + "/" + str(CurrentMap.WaveResources.size())

func SpawnEnemy(_enemy:PackedScene):
	var EnemyInst = _enemy.instantiate()
	EnemyCount+=1
	MapPath.add_child(EnemyInst)
	ActiveEnemies.append(EnemyInst)
	EnemyInst.progress_ratio = 0

func CheckWaveCompletion():
	if EnemyCount >= CurrentMap.WaveResources[WaveIDX].EnemyCapacity and ActiveEnemies.is_empty():
		WaveFinished = true
		if Health <= 0:
			DisplayFailScreen()
			return
		if MapIDX >=2 and WaveIDX == CurrentMap.WaveResources.size() - 1:
			CinematicNode.PlayKillAnim()
			GLOBALS.GAMECOMPLETED = true
			SAVELOADMANAGER.SaveConfig()
			return
		Roundstate = ROUNDSTATES.PREROUND
		RoundControls.ShowBeginRoundButton()
		if WaveIDX == CurrentMap.WaveResources.size() - 1:
			DisplayVictoryScreen()
			Roundstate = ROUNDSTATES.END
			print("STOP HERE")
		print("WAVE COMPLETED")
	pass

func DEVTOOLS_PROCESS():
	if Input.is_action_just_pressed("DEV_SpeedTime"):
		Engine.time_scale+=10
	elif Input.is_action_just_pressed("DEV_SlowTime"):
		Engine.time_scale-=10
		Engine.time_scale = clamp(Engine.time_scale,1.0,999.0)
	if Input.is_action_just_pressed("ui_accept"):
		MapIDX += 1
		MapIDX = wrap(MapIDX,0,GLOBALS.MAPS.size())
		SwapLevel(ResourceLoader.load(GLOBALS.MAPS[MapIDX]))
	Health = 999
	pass

func AddGold(_amount:int):
	Gold += _amount
	if Gold >= 1000:
		GoldText.text = str("%.2f" % Gold)
	else:
		GoldText.text = str(Gold)
	pass
func SubtractGold(_amount:int):
	Gold -= _amount
	if Gold >= 1000:
		GoldText.text = str("%.2f" % Gold)
	else:
		GoldText.text = str(Gold)
	STATS_GoldSpent += _amount
	pass
func SetGold(_amount:int):
	Gold = _amount
	if Gold >= 1000:
		GoldText.text = str("%.2f" % Gold)
	else:
		GoldText.text = str(Gold)
	pass

func AddHealth(_value:int):
	Health += _value
	HealthLabel.text = str(Health) + " HP"
	UpdateHealthVisuals()
	
func SubtractHealth(_value:int):
	Health -= _value
	HealthLabel.text = str(Health) + " HP"
	UpdateHealthVisuals()
	CheckIfDead()
	
func SetHealth(_value:int):
	Health = _value
	HealthLabel.text = str(Health) + " HP"
	UpdateHealthVisuals()
	CheckIfDead()
	
func UpdateHealthVisuals():
	if Health > 70:
		HealthLabel.modulate = Color.WHITE
	elif Health > 50:
		HealthLabel.modulate = Color.ORANGE
		HealthLabel.text = "[shake level=10]" + str(Health) + " HP"
	elif Health < 30:
		HealthLabel.modulate = Color.RED
		HealthLabel.text = "[shake level=20]" + str(Health) + " HP"
	pass

func CheckIfDead():
	if Health <= 0:
		DisplayFailScreen()
		pass

func ToggleCinematicMode(value:bool,Lerptime:float = 4.0):
	CinematicMode = value
	if CinematicMode:
		var T = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		T.parallel().tween_property(CinematicCameraNode,"rotation_degrees:x",10,Lerptime)
		T.parallel().tween_property(CinematicCameraNode,"position",Vector3(0,10,10),Lerptime)
	else:
		var T = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		T.parallel().tween_property(CinematicCameraNode,"rotation_degrees:x",0,Lerptime)
		T.parallel().tween_property(CinematicCameraNode,"position:y",0,Lerptime)
	pass

func SetSpeedModifier(_value:float):
	SpeedModifier = _value


func SwapLevel(_NewLevel:RES_Map):
	RoundControls.visible = false
	RoundControls.ShowBeginRoundButton()
	UpgradeScreen.CloseMenu()
	CurrentMap = _NewLevel
	DMAnimTree["parameters/swap/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	TableAnimPlayer.play("swap")
	await get_tree().create_timer(2.0).timeout
	for i in TowerHolder.get_child_count():
		TowerHolder.get_child(i).queue_free()
	var NewMap = _NewLevel.MapScene.instantiate()
	MapHolder.get_child(0).queue_free()
	MapHolder.add_child(NewMap)
	MapPath = NewMap.find_child("PATH",true,false)
	WaveIDX = -1
	SetHealth(100)
	RoundLabel.text = "Round 1" + "/" + str(CurrentMap.WaveResources.size())
	for i in ActiveEnemies.size():
		ActiveEnemies[i].queue_free()
	ActiveEnemies.clear()
	await DMAnimTree.animation_finished
	RoundControls.visible = true

func DisplayVictoryScreen():
	VictoryScreen.show()
	VictoryStatsText.text = "Time spent\n %s\nGold spent\n%s\nEnemies killed\n%s" % [STATS_Time, STATS_GoldSpent,STATS_Kills]
	DM_Manager.instance.PlayWinLine()
	MUSICMANAGER.MusicPlayer.stop()
	pass
	
func SelectNextLevel():
	VictoryScreen.hide()
	MapIDX+=1
	if MapIDX > MAPS.size()-1:
		GLOBALS.ChangeRoot(GLOBALS.ROOT_MAINMENU)
		return
	else:
		DM_Manager.instance.PlayAudio(DM_Manager.instance.LevelSpecificLines[MapIDX-1])
	CheckForGoldSoftlock()
	SwapLevel(MAPS[MapIDX])
	
func DisplayFailScreen():
	FailScreen.show()
	RoundControls.PausedButtonPressed()
	DM_Manager.instance.PlayFailLine()
	MUSICMANAGER.MusicPlayer.stop()
	pass
	
func RestartLevel():
	FailScreen.hide()
	if MapIDX == MAPS.size()-1:
		SwapFantasyMode(false,true)
		CheckForGoldSoftlock()
	RoundControls.visible = false
	SwapLevel(MAPS[MapIDX])
	
func CheckForGoldSoftlock():
	if Gold <= 400:
		SetGold(700)

func SwitchPerspective():
	var NextPersp = 1 if GLOBALS.PERSPECTIVE == 0 else 0
	OptionsMenuManager.instance.ChangePerspective(NextPersp)

func SmoothZoomCamera(_value:float):
	var CamTween = create_tween().set_trans(Tween.TRANS_EXPO)
	CamTween.tween_property(MainCamera,"fov",_value,2.0)

func StopPlacingTower():
	GameplayController.instance.PlacingTower = null
	MouseState = MOUSESTATES.PLAYING
	CurrentCollisionMask = GAMEPLAYCOLLISIONMASK
	PlacementArea.visible = false

func SetAllEnemyAnimationSpeed():
	for i in ActiveEnemies.size():
		ActiveEnemies[i].ChangeAnimSpeed(SpeedModifier)
