extends Behaviour
class_name AvoidBehaviour

var carLength = 32
func getDanger(position:TrackPosition, track:Track, cars, resolution:int) -> Array:
  var danger = []
  for i in range(resolution):
    danger.append(0)
  for c in cars:
    var diff = c.global_position - position.toGlobal()
    var longDistance = (c.global_position - position.toGlobal()).dot(position.trackNode.link.normalized()) #TODO: project this on something other than the link
    if longDistance < carLength / 2:
      danger[c.trackPosition.toSlot(resolution)] = 1
      danger[c.trackPosition.toSlot(resolution)+1] = 1  #TODO: calculate car's slot span
  return danger