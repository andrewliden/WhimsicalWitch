extends Spatial

###Constants###
const MOVE_BOX = Vector3(20, 11.25, 0)
const TILT_SPEEDUP = 1.33
const TILT_SLOWDOWN = 0.75
const SPIN_SPEEDUP = 1.8
###Variables###
var motionVector = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	motionVector = $witch_base.get_motion_vector()
	apply_speed_buffs()
	clamp_to_box()
	move()

func apply_speed_buffs():
	#speed up the player if they're tilted in the direction of movement.
	#slow them down if they're tilted in the direction away from movement.
	if $witch_base.rotatedLeft:
		if motionVector.x > 0:
			motionVector.x *= TILT_SPEEDUP
		else:
			motionVector.x *= TILT_SLOWDOWN
	if $witch_base.rotatedRight:
		if motionVector.x > 0:
			motionVector.x *= TILT_SLOWDOWN
		else:
			motionVector.x *= TILT_SPEEDUP
	
	if $witch_base.spinning:
		motionVector *= SPIN_SPEEDUP

#Keeps the player avatar within a box by clamping the motion vector (again)
func clamp_to_box():
	#Check if this motion vector would put the player outside the box
	if translation.x + motionVector.x > MOVE_BOX.x:
		#Find out how far outside the box this movement will put the player
		var excess = translation.x + motionVector.x - MOVE_BOX.x
		#Take out that amount from the motion vector.
		motionVector.x -= excess
	#Continue the process for negative values, and for the local Y axis
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
	

func move():
	translate(motionVector)
