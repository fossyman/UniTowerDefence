extends BetterTextureButton

@export var Effect:StatusEffect
enum APPLYRULE{FIRST,ALL,LAST}
@export var ApplyRule:APPLYRULE
@export var Price:int = 100
@export var PriceText:RichTextLabel

func _ready() -> void:
	super()
	connect("button_up",ApplyEffect)
	PriceText.text = "[img=50%]res://assets/Sprites/UI/SPR_Coins.png[/img]" + str(Price)
	pass
func ApplyEffect():
	if GameplayController.instance.ActiveEnemies.is_empty():
		NOTIFICATIONMANAGER.DisplayWarningMessage("The Round Hasn't Started!",get_global_mouse_position())
		return
	if GameplayController.instance.Gold < Price:
		NOTIFICATIONMANAGER.DisplayWarningMessage("Not enough Gold!",get_global_mouse_position())
		return
	AUDIOMANAGER.PlaySFX(AUDIOMANAGER.BUY_SFX)
	GameplayController.instance.SubtractGold(Price)
	match ApplyRule:
		APPLYRULE.FIRST:
			GameplayController.instance.ActiveEnemies[0].ApplyStatusEffect(Effect)
			pass
		APPLYRULE.ALL:
			for i in GameplayController.instance.ActiveEnemies.size():
				GameplayController.instance.ActiveEnemies[i].ApplyStatusEffect(Effect)
			pass
		APPLYRULE.LAST:
			pass
