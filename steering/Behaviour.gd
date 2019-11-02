extends Node
class_name Behaviour

func _ready():
  pass

func getInterest(resolution:int) -> Array:
  var interest = []
  for i in range(0, resolution):
    interest.append(0)
  return interest

func getDanger(resolution:int) -> Array:
  var danger = []
  for i in range(0, resolution):
    danger.append(0)
  return danger