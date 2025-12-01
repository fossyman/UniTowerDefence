extends CanvasLayer
class_name OptionsMenuManager

@export var MasterVolumeSlider:HSlider
@export var MusicVolumeSlider:HSlider
@export var SFXVolumeSlider:HSlider

@export var PerspectiveDropdown:OptionButton
@export var PerspectivePosition:Vector3 = Vector3(0.0,5.297,7.082)
@export var PerspectiveRotation:Vector3 = Vector3(-48.4,0.0,0.0)

@export var TopdownPosition:Vector3 = Vector3(0.0,10.0,0.0)
@export var TopdownRotation:Vector3 = Vector3(-90,0.0,0.0)

static var instance:OptionsMenuManager


func _enter_tree() -> void:
	instance = self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PerspectiveDropdown.connect("item_selected",ChangePerspective)
	ChangePerspective(GLOBALS.PERSPECTIVE)
	
	MasterVolumeSlider.connect("value_changed",SetAudioValue.bind(MasterVolumeSlider.value,&"Master"))
	MusicVolumeSlider.connect("value_changed",SetAudioValue.bind(MusicVolumeSlider.value,&"Music"))
	SFXVolumeSlider.connect("value_changed",SetAudioValue.bind(SFXVolumeSlider.value,&"SFX"))
	
	MasterVolumeSlider.connect("drag_ended",SaveConfig)
	MusicVolumeSlider.connect("drag_ended",SaveConfig)
	SFXVolumeSlider.connect("drag_ended",SaveConfig)
	
	UpdateAudioSliderValues()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ChangePerspective(_value:int = 0):
	GLOBALS.PERSPECTIVE = _value
	if GLOBALS.CURRENTROOT.name == "ROOT_GAMEPLAY":
		print("CHANGING")
		match _value:
			0: # Default
				GameplayController.instance.MainCamera.global_position = PerspectivePosition
				GameplayController.instance.MainCamera.global_rotation_degrees = PerspectiveRotation
				pass
			1:	#Topdown
				GameplayController.instance.MainCamera.global_position = TopdownPosition
				GameplayController.instance.MainCamera.global_rotation_degrees = TopdownRotation
				pass
	SAVELOADMANAGER.SaveConfig()
	
func UpdateAudioSliderValues():
	MasterVolumeSlider.value = AudioServer.get_bus_volume_db(0)
	MusicVolumeSlider.value = AudioServer.get_bus_volume_db(2)
	SFXVolumeSlider.value = AudioServer.get_bus_volume_db(3)
	pass
	
func SetAudioValue(_val:float,_value:float,_busName:StringName):
	if _val == -20:
		_val = -80
	var idx = AudioServer.get_bus_index(_busName)
	AudioServer.set_bus_volume_db(idx,_val)
	print("CHANGING " + str(idx))
	pass

func SaveConfig(_val:bool):
	SAVELOADMANAGER.SaveConfig()
	pass


func OptionsPressed() -> void:
	pass # Replace with function body.

func ReturnToMainMenuPressed():
	pass

func QuitPressed():
	pass
