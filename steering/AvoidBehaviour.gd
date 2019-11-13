extends Behaviour
class_name AvoidBehaviour

var carLength = 64
var carWidth = 28
var currDanger
func getDanger(position:TrackPosition, track:Track, cars, resolution:int) -> Array:
  var danger = []
  for i in range(resolution):
    danger.append(0)
  for c in cars:
    var globalDistance = c.global_position - position.toGlobal()
    var linkDistance = globalDistance.dot(position.trackNode.link.normalized())

    if linkDistance < 1.1*carLength && linkDistance > -carLength:
      var leftSlot = TrackPosition.new(
        c.trackPosition.trackNode,
        c.trackPosition.long,
        c.trackPosition.lat-carWidth/2).toSlot(resolution)
      leftSlot = clamp(leftSlot, 0, resolution-1)
      var rightSlot = TrackPosition.new(
        c.trackPosition.trackNode,
        c.trackPosition.long,
        c.trackPosition.lat+carWidth/2).toSlot(resolution)
      rightSlot = clamp(rightSlot, 0, resolution-1)
      for i in range(leftSlot, rightSlot+1):
        danger[i] = 1
      if leftSlot > 0:
        danger[leftSlot-1] = .5
      if rightSlot < resolution-1:
        danger[rightSlot+1] = .5

  currDanger = danger
  return danger