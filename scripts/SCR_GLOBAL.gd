extends Node

var ROOT_MAINMENU:PackedScene = ResourceLoader.load("res://scenes/ROOT_MainMenu.tscn")
var ROOT_CACHE:PackedScene = ResourceLoader.load("res://scenes/ROOT_Cacher.tscn")
var ROOT_GAMEPLAY:PackedScene = ResourceLoader.load("res://scenes/ROOT_gameplay.tscn")

var MAIN:Node
var ROOTCONTAINER:Node
var CURRENTROOT:Node
var CONSTANTS:Node

var MAPS:Array[String] = ["res://assets/Resources/Maps/MAP_Forest.tres","res://assets/Resources/Maps/MAP_Mountains.tres","res://assets/Resources/Maps/MAP_Castle.tres"]

var PERSPECTIVE:int = 0
var GAMECOMPLETED:bool = false

var DELTA:float

var LOADING_HINTS:Array[String] = ["Make sure to use your Power-Ups when you are in a pickle.",
									"Money is vital, spend it wisely.",
									"Hope you are having a great day :).",
									"Remember to stay hydrated",
									"Look behind you.. I said look behind you.",
									'"Heres a penny for ya" ~Old woman.',
									'"FIREBALL" ~Burnt wizard.',
									'"GRAAGH!" ~ Calm Goblin.',
									"Upgrade your towers for maximum potential.",
									"Watch out for the flying enemies.",
									'"THEY FLY NOW?" - Dwarf seeing bats for the first time.']

func _ready() -> void:
	MAIN = get_tree().root.find_child("MAIN",true,false)
	ROOTCONTAINER = MAIN.get_child(0)
	CURRENTROOT = ROOTCONTAINER.get_child(0)
	CONSTANTS = MAIN.get_child(1)

func _process(delta: float) -> void:
	DELTA = delta

func ChangeRoot(Rootpath:PackedScene):
	var NEWROOT = Rootpath.instantiate()
	ROOTCONTAINER.add_child(NEWROOT)
	CURRENTROOT.queue_free()
	CURRENTROOT = NEWROOT
	MUSICMANAGER.MusicPlayer.stop()
