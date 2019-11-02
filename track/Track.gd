extends Node2D
class_name Track

func _ready():
  setup()

func setup():
  var prev = trackNodes[-1];
  var curr = trackNodes[0]
  var next = trackNodes[1]
  calculateNodeVectors(prev, curr, next);
  for i in range(2, trackNodes.size()):
    prev = curr
    curr = next
    next = trackNodes[i]
    calculateNodeVectors(prev, curr, next)
  calculateNodeVectors(curr, next, trackNodes[0])

class TrackNodeIndexSorter:
  static func sort(a, b):
    if a.index < b.index:
      return true
    return false
    
var trackNodes = []
func addTrackNode(trackNode):
  trackNodes.push_back(trackNode)
  if trackNodes.size() > 1:
    trackNodes.sort_custom(TrackNodeIndexSorter, 'sort')

func calculateNodeVectors(prev, curr, next):
  curr.link = next.global_position - curr.global_position
  curr.normal = (next.global_position - prev.global_position).normalized()
  curr.prev = prev
  curr.next = next

  #d/sin(theta)
  curr.curvature = (curr.link/2) / sin(curr.link.angle_to(curr.normal))

func globalToTrack(globalPosition) -> TrackPosition:
  var closest = trackNodes[0]
  var closestDist = closest.global_position.distance_to(globalPosition)
  for n in trackNodes:
    n.resetColor()
    var nDist = n.global_position.distance_to(globalPosition)
    if nDist < closestDist:
      closest = n
      closestDist = nDist
    
  var registered
  var next
  if closest.to_local(globalPosition).dot(closest.normal) > 0:
    registered = closest
    next = closest.next
  else:
    registered = closest.prev
    next = closest

  registered.setColor('#f4e628')
  next.setColor('#9cf428')
  var registeredProjection = registered.to_local(globalPosition).dot(registered.normal)
  var nextProjection = next.to_local(globalPosition).dot(next.normal)
  var long = registeredProjection / (registeredProjection - nextProjection)
  var lat = registered.to_local(globalPosition).distance_to(registered.link * long)
  if registered.link.angle_to(registered.to_local(globalPosition)) < 0:
    lat *= -1
  return TrackPosition.new(registered, long, lat)

func getWidthAt(position:TrackPosition) -> float:
  var trackNode = position.trackNode
  var b = trackNode.width
  var a = trackNode.next.width - b
  return a * position.long + b

func getTarget(position:TrackPosition, ahead:float, offsetLat:float) -> TrackPosition:
  var remainder = position.trackNode.link.length() * position.long + ahead
  return walkLine(remainder, position.trackNode, offsetLat)

func walkLine(remainder, trackNode, offsetLat):
  var linkLength = trackNode.link.length()
  if remainder > linkLength:
    return walkLine(remainder - linkLength, trackNode.next, offsetLat)
  else:
    return TrackPosition.new(trackNode, remainder / linkLength, offsetLat)


class TrackPosition:
  var long = 0
  var lat = 0
  var trackNode : Node2D
  func _init(trackNode, long=0, lat=0):
    self.trackNode = trackNode
    self.long = long
    self.lat = lat

  func toGlobal():
    return trackNode.to_global(trackNode.link*long + trackNode.link.normalized().rotated(-PI/2) * lat)