extends Resource
class_name StatusEffect

@export var TickTime:float = 1.0
@export var StatusVisual:PackedScene
enum STATUSTYPE{DAMAGE,HEALING}
var StatusType:STATUSTYPE = STATUSTYPE.DAMAGE
@export var StatusPower:int = 1
@export var StatusLifetime = 1.0
