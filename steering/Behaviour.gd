extends Node
class_name Behaviour

func getInterest(position:TrackPosition, track:Track, cars, resolution:int) -> Array:
  var interest = []
  for i in range(resolution):
    interest.append(0)
  return interest

func getDanger(position:TrackPosition, track:Track, cars, resolution:int) -> Array:
  var danger = []
  for i in range(resolution):
    danger.append(0)
  return danger