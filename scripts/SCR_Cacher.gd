extends Node3D

var NextScene = GLOBALS.ROOT_GAMEPLAY
@export var Materials:Array[Material]
@export var PreviewMesh:MeshInstance3D
@export var LoadingScreen:LoadingOverlay

var MaterialSwapTime:float = 0.1
var CurrentSwapTime:float = 0.1

var MatIDX = 0

var CacheFinished:bool = false
var BeginCaching = false

func _ready() -> void:
	LoadingScreen.LoadingBar.max_value = Materials.size()
	BeginCaching = true

func _process(delta: float) -> void:
	if !BeginCaching:
		return
	CurrentSwapTime -= delta
	
	if !CacheFinished && CurrentSwapTime <= 0.0:
		MaterialCaching()
		CurrentSwapTime = MaterialSwapTime
		print(MatIDX / LoadingScreen.LoadingBar.max_value)
		LoadingScreen.LoadingProgress = MatIDX

	
	if CacheFinished:
		GLOBALS.ChangeRoot(GLOBALS.ROOT_MAINMENU)


func MaterialCaching():
	if MatIDX > Materials.size()-1:
		CacheFinished = true
		return
	PreviewMesh.material_override = Materials[MatIDX]
	MatIDX+=1
	pass
