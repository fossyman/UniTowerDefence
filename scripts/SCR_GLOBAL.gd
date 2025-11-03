extends Node

var ROOT_MAINMENU:PackedScene = ResourceLoader.load("res://scenes/ROOT_MainMenu.tscn")
var ROOT_CACHE:PackedScene = ResourceLoader.load("res://scenes/ROOT_Cacher.tscn")
var ROOT_GAMEPLAY:PackedScene = ResourceLoader.load("res://scenes/ROOT_gameplay.tscn")

var MAIN:Node
var ROOTCONTAINER:Node
var CURRENTROOT:Node
var CONSTANTS:Node

func _ready() -> void:
	MAIN = get_tree().root.find_child("MAIN",true,false)
	ROOTCONTAINER = MAIN.get_child(0)
	CURRENTROOT = ROOTCONTAINER.get_child(0)
	CONSTANTS = MAIN.get_child(1)

func ChangeRoot(Rootpath:PackedScene):
	var NEWROOT = Rootpath
	NEWROOT.instantiate()
	ROOTCONTAINER.add_child(NEWROOT)
	CURRENTROOT.queue_free()
	CURRENTROOT = NEWROOT
	
