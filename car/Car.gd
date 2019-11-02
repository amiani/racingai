extends RigidBody2D

export(NodePath) var trackPath
var track
onready var target = $Target
func _ready():
  track = get_node(trackPath)

signal steerAt(angle)
signal position(R)
export var ahead = 250
func _process(delta):
  emit_signal('position', track.globalToTrack(global_position))
  target.global_position = track.getTarget(global_position, ahead)

  emit_signal('steerAt', Vector2(1,0).angle_to(target.position))

func getTrackPosition():
  return track.globalToTrack(global_position)