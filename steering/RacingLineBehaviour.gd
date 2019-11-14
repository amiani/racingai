extends Behaviour
class_name RacingLineBehaviour

func getInterest(position:TrackPosition, track: Track, cars, resolution:int):
  var lineSlot = getLineSlot(position, resolution)
  var interest = []
  for i in range(resolution):
    interest.append(-.044 * abs(lineSlot - i) + .5)
  return interest
  
func getLineSlot(position:TrackPosition, resolution):
  var nodeLineLatFromLeft = position.trackNode.leftWidth + position.trackNode.lineOffset
  var nextLineLatFromLeft = position.trackNode.next.leftWidth + position.trackNode.next.lineOffset
  var lineLatFromLeft = (1-position.long)*nodeLineLatFromLeft + position.long*nextLineLatFromLeft
  var slotWidth = position.getTrackWidth() / resolution
  return floor(lineLatFromLeft / slotWidth)