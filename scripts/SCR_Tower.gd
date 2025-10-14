extends Resource
class_name Tower

@export var Name:String
@export var Icon:Texture
@export var TowerScn:PackedScene
@export var Price:int
@export var PlacementRange:float = 1.0
@export var Stats:Array[Stat]

func GetCurrentAttackRange() -> float:
	return Stats[1].GetAmount()
	pass
