extends Node

var ActiveNotifications:Array[RichTextLabel]
var WiggleTime:float

func _process(delta: float) -> void:
	WiggleTime += delta
	for i in ActiveNotifications.size():
		ActiveNotifications[i].rotation = sin(WiggleTime * 10.0 + i) * 0.2

func DisplayPopup(_message:String,_position:Vector2,_color:Color,_risetime:float,_hangtime:float,_shakeAmp:float = 0.5,_shakeFreq:float = 1.0):
	var Notif = RichTextLabel.new()
	var NotifTween = create_tween()
	NotifTween.connect("finished",DestroyNotification.bind(Notif))
	get_tree().root.add_child(Notif)
	Notif.mouse_filter = Control.MOUSE_FILTER_IGNORE
	Notif.clip_contents = false
	Notif.fit_content = true
	Notif.size.x = 200
	Notif.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	Notif.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	Notif.pivot_offset = Notif.size/2.0
	Notif.position = _position + -Notif.pivot_offset
	Notif.text = _message
	Notif.modulate = _color
	ActiveNotifications.append(Notif)
	NotifTween.parallel().tween_property(Notif,"position:y",Notif.global_position.y + -_risetime,_hangtime)
	NotifTween.parallel().tween_property(Notif,"modulate:a",0,_hangtime)

	pass

func DestroyNotification(_notif:RichTextLabel):
	print("DONE")
	ActiveNotifications.erase(_notif)
	_notif.queue_free()
	pass


func DisplayWarningMessage(_message:String,_pos:Vector2,Shakespeed:float = 5.0):
	DisplayPopup(_message,_pos,Color.RED,50,2,0.1,Shakespeed)
