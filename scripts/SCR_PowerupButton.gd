extends BetterTextureButton

@export var Effect:StatusEffect
enum APPLYRULE{FIRST,ALL,LAST}
@export var ApplyRule:APPLYRULE
@export var Price:int = 100

func _ready() -> void:
	connect("button_up",ApplyEffect)
	pass
func ApplyEffect():
	if GameplayController.instance.Gold < Price:
		return
	GameplayController.instance.SubtractGold(Price)
	match ApplyRule:
		APPLYRULE.FIRST:
			GameplayController.instance.ActiveEnemies[0].ApplyStatusEffect(Effect)
			pass
		APPLYRULE.ALL:
			pass
		APPLYRULE.LAST:
			pass
