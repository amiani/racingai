extends Node2D

var behaviours : Array
var car = get_parent()
func _ready():
  var racingLineBehaviour = new RacingLineBehaviour(track)
  var avoidBehaviour = new AvoidBehaviour(cars)
  behaviours = [racingLineBehaviour, avoidBehaviour]

func _process(delta):
  var carLat = car.getTrackPosition().lat
  var carSlot = getCarSlot(carLat, 200, resolution)
  var offsetBrake = getOffsetBrake(behaviours, carSlot)
  var target = getTarget(offsetBrake)
  var controls = getControls(target)

func getCarSlot(carLat, trackWidth, resolution):
  var slotWidth = trackWidth/resolution
  var carLatTranslated = carLat + trackWidth / 2
  return floor(carLatTranslated / slotWidth)

var resolution = 10
func getOffsetBrake(behaviours, carSlot):
  var danger = [].resize(resolution)
  var interest = [].resize(resolution)
  for b in behaviours:
    var currDanger = b.getDanger(resolution)
    var currInterest = b.getInterest(resolution)
    for i in range(0, resolution):
      danger[i] = max(danger[i], currDanger[i])
      interest[i] = max(interest[i], currInterest[i])
  
  interest = maskInterest(interest, danger, carSlot)
  var maxIndex = 0
  var maxInterest = interest[0]
  for i in range(resolution):
    if interest[i] > maxInterest:
      maxIndex = i
  
  return Vector2(maxIndex, 0)

func maskInterest(interest, danger, carSlot):
  var currDanger = danger[carSlot]
  var i = carSlot
  while (danger[i] < currDanger && i >= 0):
    currDanger = danger[i]
    i--
  for j in range(i, -1):
    interest[j] = 0
  
  while (danger[i] < currDanger && i < interest.length):
    currDanger = danger[i]
    i++
  for j in range(i, interest.length):
    interest[j] = 0

func getTarget(offsetBrake):
  pass

func getControls(target):
  pass