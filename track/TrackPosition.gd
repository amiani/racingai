extends Reference
class_name TrackPosition

var long = 0
var lat = 0
var trackNode : TrackNode
var trackWidth setget setTrackWidth, getTrackWidth

func _init(trackNode:TrackNode, long=0, lat=0):
  self.trackNode = trackNode
  self.long = long
  self.lat = lat

func getLatNormal() -> Vector2:
  return ((1-long)*trackNode.normal + long*trackNode.next.normal).rotated(PI/2)

func toGlobal() -> Vector2:
  return trackNode.to_global(toLocal())

func toLocal() -> Vector2:
  return long*trackNode.link + lat*getLatNormal()

func toSlot(resolution):
  var trackWidth = getTrackWidth()
  var slotWidth = trackWidth / resolution
  var latTranslated = lat + trackWidth / 2
  return floor(latTranslated / slotWidth)

func setTrackWidth(w):
  print("ERROR: Can't set track width")

func getTrackWidth() -> float:
  if !trackWidth:
    var b = trackNode.leftWidth + trackNode.rightWidth
    var m = trackNode.next.leftWidth + trackNode.next.rightWidth - b
    trackWidth = m * long + b
  return trackWidth

func lineDistanceTo(position:TrackPosition) -> float:
  return .0