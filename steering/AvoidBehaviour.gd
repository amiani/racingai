#extends "res://car/steering/Behaviour.gd"
extends Behaviour
class_name AvoidBehaviour

var cars : Array
func _init(cars:Array):
  self.cars = cars

func _ready():
	pass

func getDanger(resolution:int):
  pass