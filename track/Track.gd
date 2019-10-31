extends Node2D

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

func globalToTrack(R):
  var closest = trackNodes[0]
  var closestDist = closest.global_position.distance_to(R)
  for n in trackNodes:
    n.resetColor()
    var nDist = n.global_position.distance_to(R)
    if nDist < closestDist:
      closest = n
      closestDist = nDist
    
  var registered
  var next
  if closest.to_local(R).dot(closest.normal) > 0:
    registered = closest
    next = closest.next
  else:
    registered = closest.prev
    next = closest

  registered.setColor('#f4e628')
  next.setColor('#9cf428')
  var registeredProjection = registered.to_local(R).dot(registered.normal)
  var nextProjection = next.to_local(R).dot(next.normal)
  var long = registeredProjection / (registeredProjection - nextProjection)
  var lat = registered.to_local(R).distance_to(registered.link * long)
  if registered.link.angle_to(registered.to_local(R)) < 0:
    lat *= -1
  return {
    long =  long,
    lat = lat,
    registered = registered
  }

func getTarget(R, ahead):
  var trackPosition = globalToTrack(R)
  var registered = trackPosition.registered
  var next = registered.next
  var distToNext = (1 - trackPosition.long) * registered.link.length()
  if distToNext > ahead:
    return registered.to_global(registered.link.normalized()*ahead + trackPosition.long*registered.link)
  else:
    return next.to_global(next.link.normalized()*(ahead-distToNext))