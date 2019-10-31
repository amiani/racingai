extends Label

func _ready():
	pass

func _on_Car_position(trackPosition):
  text = str(trackPosition.long) + ', ' + str(trackPosition.lat)