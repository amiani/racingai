extends Node
class_name SteeringController

var behaviours : Array
var car : Car
func _ready():
  car = get_parent()
  behaviours = get_children()

var resolution = 10
func _process(delta):
  var carPos = car.trackPosition
  var trackWidth = carPos.trackWidth
  var slotWidth = trackWidth/resolution
  var offsetBrake = getOffsetBrake(behaviours, carPos, carPos.toSlot(resolution))
  var target = getTarget(carPos, offsetBrake, slotWidth, trackWidth)
  #var controls = getControls(target)

func getOffsetBrake(behaviours, carPos, carSlot):
  var danger = []
  var interest = []
  var cars = car.get_parent().get_children()
  cars.remove(car.get_index())
  for i in range(resolution):
    interest.append(0)
    danger.append(0)
  for b in behaviours:
    var currInterest = b.getInterest(carPos, car.track, cars, resolution)
    var currDanger = b.getDanger(carPos, car.track, cars, resolution)
    for i in range(resolution):
      danger[i] = max(danger[i], currDanger[i])
      interest[i] = max(interest[i], currInterest[i])
  
  interest = maskInterest(interest, danger, carSlot)
  var maxIndex = 0
  var maxInterest = interest[0]
  for i in range(resolution):
    if interest[i] > maxInterest:
      maxIndex = i
      maxInterest = interest[i]
  
  return {
    slot = maxIndex,
    brake = 0 #TODO: calculate how much braking is needed
  }

func maskInterest(interest, danger, carSlot):
  var maskedInterest : Array
  if carSlot >= 0 && carSlot < 10:
    maskedInterest = interest.duplicate()
    var currDanger = danger[carSlot]
    var i = carSlot
    while i >= 0 && danger[i] <= currDanger:
      currDanger = danger[i]
      i-=1
    for j in range(i, -1, -1):
      maskedInterest[j] = 0

    i = carSlot
  currDanger = danger[i]
    while i < interest.size() && danger[i] <= currDanger:
      currDanger = danger[i]
      i+=1
    for j in range(i, interest.size()):
      maskedInterest[j] = 0
  else:
    for i in range(interest.size()):
      maskedInterest.append(0)

  return maskedInterest
  

var ahead = 200
func getTarget(carPos, offsetBrake, slotWidth, trackWidth):
  var maxAhead = 300
  var minAhead = 150
  var m = (maxAhead-minAhead)/(3902-271)
  var long = m * carPos.trackNode.next.curvature + (minAhead - m * 271)
  var offsetLat = (slotWidth * offsetBrake.slot + slotWidth / 2) - trackWidth / 2
  var targetPosition = car.track.getTarget(carPos, long, offsetLat)
  car.target.global_position = targetPosition.toGlobal()

func getControls(target):
  pass