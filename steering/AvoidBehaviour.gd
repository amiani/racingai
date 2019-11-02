extends Behaviour
class_name AvoidBehaviour

var cars : Array
func _init(cars:Array):
  self.cars = cars

func getDanger(position:TrackPosition, track:Track, cars, resolution:int):
  pass