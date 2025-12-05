extends Button

@export var TowerRes:Tower

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed",Btn_Pressed)
	get_child(0).texture = TowerRes.Icon
	get_child(1).text = TowerRes.Name
	get_child(2).text = str(TowerRes.Price)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Btn_Pressed():
	if GameplayController.instance.Gold < TowerRes.Price:
		print("YOU ARE BROKE")
		DM_Manager.instance.PlayNoGoldLine()
		return
	GameplayController.instance.CurrentCollisionMask = GameplayController.instance.PLACEMENTCOLLISIONMASK
	GameplayController.instance.PlacingTower = TowerRes
	GameplayController.instance.MouseState = GameplayController.instance.MOUSESTATES.PLACING
	GameplayController.instance.PlacementDecal.size = Vector3(TowerRes.PlacementRange+0.5,2.0,TowerRes.PlacementRange+0.5)
	print(str(TowerRes.Name) + " OR " + str(GameplayController.instance.PlacingTower.Stats.size()))
	GameplayController.instance.PlacementAttackRangeDecal.size = Vector3(TowerRes.Stats[1].Amount[0]+1,2.0,TowerRes.Stats[1].Amount[0]+1)
	GameplayController.instance.PlacementCollisionChecker.shape.radius = TowerRes.PlacementRange
	GameplayController.instance.TowerPurchaseScreen.ToggleMenu()
	GameplayController.instance.PlacementArea.visible = true
	
	TowerPurchaseMenu.instance.ToggleStopTowerPlacement()
	pass
