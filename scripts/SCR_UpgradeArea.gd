extends Node
class_name UpgradeAreaManager

@export var TowerName:RichTextLabel
@export var TowerIcon:TextureRect
@export var UpgradeButtonContainer:Control

@export var ButtonPrefab:PackedScene

var SelectedTower:Tower

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func populateSettings(_scene:TowerScene):
	var settings = _scene.TowerResource as Tower
	TowerName.text = settings.Name
	TowerIcon.texture = settings.Icon
	for i in UpgradeButtonContainer.get_child_count():
		UpgradeButtonContainer.get_child(i).queue_free()
		
	for i in settings.Stats.size():
		var btn = ButtonPrefab.instantiate() as StatUpgradeButton
		UpgradeButtonContainer.add_child(btn)
		btn.Icon.texture = settings.Stats[i].Icon
		btn.NameText.text = settings.Stats[i].Name
		btn.PriceText.text = "$" + str(settings.Stats[i].GetCost())
		btn.UpgradeStat = settings.Stats[i]
		btn.UpgradingTower = _scene
		btn.pressed.connect(btn.Pressed)
	print("POPULATING")
	pass
