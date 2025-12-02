extends Node

@export var MusicPlayer:AudioStreamPlayer

@onready var SongList:Array[SongMetadata] = [ResourceLoader.load("res://assets/Resources/Songs/RES_PlanesSong.tres"),ResourceLoader.load("res://assets/Resources/Songs/RES_MountainSong.tres"),ResourceLoader.load("res://assets/Resources/Songs/RES_The Well of Souls_META.tres")]

@export var SongTitleText:RichTextLabel

var CurrentSongString:String

var SongIDX:int = 1



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var Player = AudioStreamPlayer.new()
	add_child(Player)
	MusicPlayer = Player
	Player.bus = &"Music"
	Player.volume_db = -10
	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if SongTitleText.position.x > (SongTitleText.size.x + SongTitleText.text.length()) * -0.475:
		#SongTitleText.position.x -= (delta * 100)
	#else:
		#SongTitleText.position.x = 0
	#pass

func PickNewSong(_SpecificSong:AudioStream = null,_restart:bool = false,_bus= &"Music"):
	if MusicPlayer.stream == _SpecificSong && _restart == false:
		return
	var Song
	if !_SpecificSong:
		SongIDX +=1
		SongIDX = wrap(SongIDX,0,SongList.size())
		print(SongIDX)
		Song = SongList[SongIDX].SongAsset
	Song = _SpecificSong
	MusicPlayer.bus = _bus
	MusicPlayer.stream = Song
	MusicPlayer.play()
	#CurrentSongString = Song.SongName + " - " + Song.SongArtist + " - " + Song.SongAlbum + " - " + Song.SongYear + " - "
	#SongTitleText.text = CurrentSongString + CurrentSongString
	#SongTitleText.size.x = CurrentSongString.length()
	#SongTitleText.position.x = 400
