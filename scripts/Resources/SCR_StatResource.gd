extends Resource
class_name Stat

@export var Name:String
@export var Icon:CompressedTexture2D
@export var Amount:Array[float]
@export var Level:int
@export var Cost:Array[int]

func UpgradeLevel():
	Level +=1

func GetAmount() -> float:
	return Amount[Level]
	pass
	
func GetCost() -> int:
	return Cost[Level]
	pass
