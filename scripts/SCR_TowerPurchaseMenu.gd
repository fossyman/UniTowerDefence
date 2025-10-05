extends Control
class_name TowerPurchaseMenu

@export var OpenPosition:Vector2
var OpenTween:Tween
var IsMenuOpen:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ToggleMenu():
	IsMenuOpen = !IsMenuOpen
	
	if OpenTween:
		OpenTween.kill()
	OpenTween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	if IsMenuOpen:
		OpenTween.tween_property(self,"position",OpenPosition,0.5)
	else:
		OpenTween.tween_property(self,"position",Vector2(1280,0),0.5)
