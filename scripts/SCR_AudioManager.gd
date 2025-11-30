extends Node
class_name AudioManager

var ActiveSFXSources:Array[AudioStreamPlayer]

@onready var BUY_SFX = ResourceLoader.load("res://assets/Audio/SFX/BuySFX.ogg") as AudioStream
@onready var SLIDE_SFX = ResourceLoader.load("res://assets/Audio/SFX/MenuSlide.ogg") as AudioStream


func PlaySFX(_sample:AudioStream,_pitchMod:float = 0.1,_VolMod:float = 0.0,BUS:StringName = &"SFX"):
	var player = AudioStreamPlayer.new()
	player.bus = BUS
	player.stream = _sample
	player.autoplay = true
	player.volume_db = _VolMod
	player.pitch_scale = 1.0 + randf_range(-_pitchMod,_pitchMod)
	add_child(player)
	ActiveSFXSources.append(player)
	player.connect("finished",SFX_FINISHED.bind(player))

func SFX_FINISHED(_sfxplayer:AudioStreamPlayer):
	ActiveSFXSources.erase(_sfxplayer)
	_sfxplayer.queue_free()
	
	pass
