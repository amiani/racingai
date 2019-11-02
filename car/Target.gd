extends Node2D
class_name Target

export(Color, RGB) var color
func _draw():
  draw_circle(Vector2(), 8, Color(color))