extends Behaviour
class_name RacingLineBehaviour

var track : Track
func _init(track:Track):
  self.track = track

func getInterest(position:TrackPosition, resolution:int):
  var lineSlot = getLineSlot(position, resolution)
  var interest = []
  for i in range(0, resolution):
    interest.append(-.044 * abs(lineSlot - i) + .5)
  return interest
  
func getLineSlot(position:TrackPosition, resolution):
  return resolution / 2 - 5