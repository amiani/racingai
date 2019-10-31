extends RigidBody2D

export var isDrive = false

func _enter_tree():
  var joint = PinJoint2D.new()
  joint.node_a = get_parent().get_path()
  joint.node_b = get_path()
  add_child(joint)

func getForwardNormal():
  return Vector2(cos(global_rotation), sin(global_rotation))

func getForwardSpeed(velocity):
  return getForwardNormal().dot(velocity)

#func getForwardVelocity():
  #return getForwardSpeed() * getForwardNormal()

func getLateralSpeed():
  return getForwardNormal().rotated(PI/2).dot(linear_velocity)

export var isPrint = false
var maxLateralDrag = 110000
func updateFriction(state):
  var lateralDrag = -getLateralSpeed() * mass / state.step
  lateralDrag = clamp(lateralDrag, -maxLateralDrag, maxLateralDrag)
  applied_force += Vector2(0, lateralDrag).rotated(global_rotation);

  #state.apply_torque_impulse(.03 * inertia * -state.angular_velocity)

  var dragSpeed = -1 * getForwardSpeed(state.linear_velocity) / state.step
  applied_force += Vector2(dragSpeed, 0).rotated(global_rotation)

var desiredAngle = 0
func _on_Car_steerAt(angle):
  desiredAngle = angle

var lockAngle = PI/5
var turnSpeed = 3*PI/2 /60
func updateTurn():
  var angleToTurn = 0
  if isDrive:
    desiredAngle = clamp(desiredAngle, -lockAngle, lockAngle)
    angleToTurn = desiredAngle - rotation
    if angleToTurn > turnSpeed:
      angleToTurn = turnSpeed + rotation
    elif angleToTurn < -turnSpeed:
      angleToTurn = -turnSpeed + rotation
    else:
      angleToTurn += rotation

  rotation = angleToTurn


var maxForwardSpeed = 3000
var maxBackwardSpeed = -200
var maxDriveForce = mass * 1000
func updateDrive(state):
  var desiredSpeed = maxForwardSpeed

  var force = 0
  var forwardSpeed = getForwardSpeed(state.linear_velocity)
  if desiredSpeed > forwardSpeed: force = maxDriveForce
  elif desiredSpeed < forwardSpeed && desiredSpeed != 0: force = -maxDriveForce
  else: return

  applied_force += Vector2(force, 0).rotated(global_rotation)

func _integrate_forces(state):
  applied_force = Vector2()
  updateFriction(state)
  updateTurn()
  if (isDrive):
    updateDrive(state)
