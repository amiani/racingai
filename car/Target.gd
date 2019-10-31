extends Node2D

export(Color, RGB) var color
func _draw():
  draw_circle(Vector2(), 8, Color(color))