extends Button
class_name StatUpgradeButton

@export var Icon:TextureRect
@export var NameText:RichTextLabel
@export var PriceText:RichTextLabel

@export var UpgradeStat:Stat
@export var UpgradingTower:TowerScene

func Pressed():
	if !UpgradeStat:
		return
	
	if GameplayController.instance.Gold >= UpgradeStat.Cost[UpgradeStat.Level]:
		GameplayController.instance.SubtractGold(UpgradeStat.Cost[UpgradeStat.Level])
		UpgradeStat.UpgradeLevel()
		GameplayController.instance.UpgradeScreen.SelectedTowerScene.refreshStats()
		SetValues()
		AUDIOMANAGER.PlaySFX(AUDIOMANAGER.BUY_SFX)
		GameplayController.instance.UpgradeScreen.SelectedTowerScene.ShowRangeDecal()
	else:
		print(str(UpgradeStat.Cost[UpgradeStat.Level]) + " needed. You have: " + str(GameplayController.instance.Gold))
	pass
	
func SetValues():
	if UpgradeStat.Level != UpgradeStat.Cost.size()-1:
		PriceText.text = "$" + str(UpgradeStat.Cost[UpgradeStat.Level])
		disabled = false
	else:
		PriceText.text = "Maxed out"
		disabled = true
		
