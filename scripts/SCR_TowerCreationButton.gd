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
	var Size:Vector3 = Vector3.ONE * TowerRes.PlacementRange
	GameplayController.instance.PlacementArea.get_child(0).scale = Size
	print(str(TowerRes.Name) + " OR " + str(GameplayController.instance.PlacingTower.Stats.size()))
	GameplayController.instance.PlacementRangeDecal.scale = Vector3.ONE * TowerRes.Stats[1].Amount[TowerRes.Stats[1].Level]
	GameplayController.instance.PlacementCollisionChecker.shape.radius = TowerRes.PlacementRange
	GameplayController.instance.TowerPurchaseScreen.ToggleMenu()
	GameplayController.instance.PlacementArea.visible = true
	pass
