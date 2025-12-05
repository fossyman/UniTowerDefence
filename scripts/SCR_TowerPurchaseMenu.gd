extends Control
class_name TowerPurchaseMenu

static var instance:TowerPurchaseMenu

@export var ClickSFX:AudioStream
var StopTowerPlacementTween:Tween
@export var StopTowerPlacementButton:Button
@export var StopTowerPlacementButtonOpenPosition:Vector2
@export var StopTowerPlacementButtonClosedPosition:Vector2


@export var MenuOpenPosition:Vector2
var OpenTween:Tween
var IsMenuOpen:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ToggleMenu():
	IsMenuOpen = !IsMenuOpen
	AUDIOMANAGER.PlaySFX(AUDIOMANAGER.SLIDE_SFX)
	if OpenTween:
		OpenTween.kill()
	OpenTween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	if IsMenuOpen:
		OpenTween.parallel().tween_property(self,"position",MenuOpenPosition,0.5)
	else:
		OpenTween.parallel().tween_property(self,"position",Vector2(1280,0),0.5)

func ToggleStopTowerPlacement():
	if StopTowerPlacementTween:
		StopTowerPlacementTween.kill()
	StopTowerPlacementTween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	if GameplayController.instance.MouseState == GameplayController.instance.MOUSESTATES.PLACING:
		StopTowerPlacementTween.tween_property(StopTowerPlacementButton,"position",StopTowerPlacementButtonOpenPosition,0.5)
	if GameplayController.instance.MouseState == GameplayController.instance.MOUSESTATES.PLAYING:
		StopTowerPlacementTween.tween_property(StopTowerPlacementButton,"position",StopTowerPlacementButtonClosedPosition,0.5)

func StopTowerPlacement() -> void:
	AUDIOMANAGER.PlaySFX(ClickSFX,0.1,-5)
	GameplayController.instance.StopPlacingTower()
	ToggleStopTowerPlacement()
	pass # Replace with function body.
