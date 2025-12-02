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
	
	if UpgradeStat.Level >= UpgradeStat.Amount.size()-1:
		DM_Manager.instance.PlayMaxLevelUpgradeLine()
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
		DM_Manager.instance.PlayNoGoldLine()
	pass
	
func SetValues():
	if UpgradeStat.Level != UpgradeStat.Cost.size()-1:
		PriceText.text = "$" + str(UpgradeStat.Cost[UpgradeStat.Level])
	else:
		PriceText.text = "Maxed out"
		
