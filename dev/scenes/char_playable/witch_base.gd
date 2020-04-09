extends KinematicBody

###Constants###
const MOVE_BOX = Vector3(20, 11.25, 0)
const MOUSE_SENSITIVITY = 0.25
const MAX_SPEED = 50

###Variables###
var motionVector = Vector3()
var nudgeVector = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collisions = move(delta)


func _input(event):
	if event is InputEventMouseMotion:
		mouse_movement(event)

func mouse_movement(event):
	#Get a motion vector from the mouse
	motionVector = Vector3(event.relative.x, event.relative.y, 0) * - MOUSE_SENSITIVITY


#Moves the player.  Returns any collisions
func move(delta):
	clamp_motion_speed(delta)
	clamp_to_box()
	#Test for collisions, translate the player model, and return the set of collisions
	var collisions = move_and_collide(motionVector, false, true, true)
	translate(motionVector);
	return collisions

#Clamps the motion speed to a maximum value.  Also takes care of applying delta to the motion speed.
func clamp_motion_speed(delta):
	motionVector *= delta
	if motionVector.length() > MAX_SPEED * delta:
		motionVector = motionVector.normalized() * MAX_SPEED * delta

#Keeps the player avatar within a box by clamping the motion vector (again)
func clamp_to_box():
	#Clamp along X
	if translation.x + motionVector.x > MOVE_BOX.x:
		var excess = translation.x + motionVector.x - MOVE_BOX.x
		motionVector.x -= excess
	if translation.x + motionVector.x < -MOVE_BOX.x:
		var excess = translation.x + motionVector.x + MOVE_BOX.x
		motionVector.x -= excess
	#Clamp along Y
	if translation.y + motionVector.y > MOVE_BOX.y:
		var excess = translation.y + motionVector.y - MOVE_BOX.y
		motionVector.y -= excess
	if translation.y + motionVector.y < -MOVE_BOX.y:
		var excess = translation.y + motionVector.y + MOVE_BOX.y
		motionVector.y -= excess
