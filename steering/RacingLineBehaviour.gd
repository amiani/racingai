extends Behaviour
class_name RacingLineBehaviour

func getInterest(position:TrackPosition, track: Track, cars, resolution:int):
  var lineSlot = getLineSlot(position, resolution)
  var interest = []
  for i in range(resolution):
    interest.append(-.044 * abs(lineSlot - i) + .5)
  return interest
  
func getLineSlot(position:TrackPosition, resolution):
  return resolution / 2 - 2