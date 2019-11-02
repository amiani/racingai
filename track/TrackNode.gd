tool
extends Node2D
class_name TrackNode

export var isStart = false
export var leftWidth = 100
export var rightWidth = 100
export var index = 0
var link : Vector2
var linkLength setget setLinkLength, getLinkLength
func setLinkLength(l):
  print('stop it')
func getLinkLength():
  return link.length()
var normal : Vector2
var curvature = 0
var color = '#fa37c6'
var distance = 99999
var next : Node2D
var prev : Node2D

func _ready():
  get_parent().addTrackNode(self)
  
func _draw():
  draw_circle(Vector2(), 8, Color(color))
  draw_line(Vector2(), link, Color('#0066ff'))
  draw_line(Vector2(), normal*20, Color('#ff0000'))

  var leftPoint = leftWidth*normal.rotated(-PI/2)
  var rightPoint = rightWidth*normal.rotated(PI/2)
  var nextLeftPoint = to_local(next.to_global(next.leftWidth * next.normal.rotated(-PI/2)))
  var nextRightPoint = to_local(next.to_global(next.leftWidth * next.normal.rotated(PI/2)))
  draw_line(leftPoint, rightPoint, Color('#000000'))
  draw_line(leftPoint, nextLeftPoint, Color('#000000'))
  draw_line(rightPoint, nextRightPoint, Color('#000000'))


func resetColor():
  color = '#fa37c6'
  update()

func setColor(c):
  color = c
  update()