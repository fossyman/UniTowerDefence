extends Node3D

var NextScene = GLOBALS.ROOT_GAMEPLAY

@export var Materials:Array[Material]
@export var PreviewMesh:MeshInstance3D
func _ready() -> void:
	for i in Materials.size():
		PreviewMesh.material_override = Materials[i]
		await get_tree().create_timer(0.1)
	GLOBALS.ChangeRoot(GLOBALS.ROOT_GAMEPLAY)
