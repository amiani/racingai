extends Label

func _ready():
	pass

func _on_Car_position(trackPosition):
  text = str(trackPosition.long) + ', ' + str(trackPosition.lat)

func _on_DebugToggle_toggled(button_pressed):
	visible = !visible
