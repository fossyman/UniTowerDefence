extends Resource
class_name Stat

@export var Name:String
@export var Icon:CompressedTexture2D
@export var Amount:Array[float]
@export var Level:int
@export var Cost:Array[int]

func Setup(_name:String,_icon:CompressedTexture2D,_amount:Array[float],_level:int,_cost:Array[int]) -> void:
	Name = _name
	Icon = _icon
	Amount = _amount
	Level = _level
	Cost = _cost
	pass

func UpgradeLevel():
	Level +=1

func GetAmount() -> float:
	return Amount[Level]
	pass
	
func GetCost() -> int:
	return Cost[Level]
	pass
