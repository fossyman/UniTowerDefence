extends Control
class_name UpgradeAreaManager

@export var ClosedPosition:Vector2

var IsOpen:bool = false
var OpenTween:Tween

@export var TowerName:RichTextLabel
@export var TowerIcon:TextureRect
@export var UpgradeButtonContainer:Control

@export var ButtonPrefab:PackedScene

var SelectedTower:Tower
var SelectedTowerScene:TowerScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func DeselectTower():
	if SelectedTower && SelectedTowerScene:
		SelectedTowerScene.HideRangeDecal()
	SelectedTower = null
	SelectedTowerScene = null

func populateSettings(_scene:TowerScene):
	if SelectedTower and SelectedTowerScene:
		DeselectTower()
	SelectedTower = _scene.TowerResource
	SelectedTowerScene = _scene
	SelectedTowerScene.ShowRangeDecal()
	TowerName.text = _scene.TowerResource.Name
	TowerIcon.texture = _scene.TowerResource.Icon
	for i in UpgradeButtonContainer.get_child_count():
		UpgradeButtonContainer.get_child(i).queue_free()
		
	for i in _scene.Stats.size():
		var btn = ButtonPrefab.instantiate() as StatUpgradeButton
		UpgradeButtonContainer.add_child(btn)
		btn.Icon.texture = _scene.Stats[i].Icon
		btn.NameText.text = _scene.Stats[i].Name
		btn.PriceText.text = "$" + str(_scene.Stats[i].GetCost())
		btn.UpgradeStat = _scene.Stats[i]
		btn.UpgradingTower = _scene
		btn.pressed.connect(btn.Pressed)
		btn.SetValues()
	print("POPULATING")
	ToggleMenu(true)
	
	pass

func ToggleMenu(_value:bool = false,Speed:float = 1.0):
	if _value == IsOpen:
		return
	if OpenTween:
		OpenTween.kill()
	OpenTween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	IsOpen = _value
	if IsOpen:
		OpenTween.tween_property(self,"position:x",0,Speed)
	else:
		OpenTween.tween_property(self,"position:x",ClosedPosition.x,Speed)
	AUDIOMANAGER.PlaySFX(AUDIOMANAGER.SLIDE_SFX)
	pass

func CloseMenu(_time:float = 1.0):
	ToggleMenu(false,_time)
	if SelectedTowerScene:
		SelectedTowerScene.HideRangeDecal()
	DeselectTower()

func SellSelectedTower() -> void:
	GameplayController.instance.AddGold(SelectedTower.Price)
	AUDIOMANAGER.PlaySFX(AUDIOMANAGER.BUY_SFX)
	SelectedTowerScene.queue_free()
	CloseMenu(0.1)
	pass # Replace with function body.
