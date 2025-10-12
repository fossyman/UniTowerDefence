extends Button

@export var TowerRes:Tower

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed",Btn_Pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Btn_Pressed():
	GameplayController.instance.PlacingTower = TowerRes
	GameplayController.instance.MouseState = GameplayController.instance.MOUSESTATES.PLACING
	var Size:Vector3 = Vector3.ONE * TowerRes.PlacementRange
	GameplayController.instance.PlacementDecal.get_child(0).scale = Size
	GameplayController.instance.PlacementDecal.get_child(1).scale = Vector3.ONE * TowerRes.Stats[1].Amount
	GameplayController.instance.PlacementDecal.get_child(2).shape.radius = TowerRes.PlacementRange
	GameplayController.instance.TowerPurchaseScreen.ToggleMenu()
	pass
