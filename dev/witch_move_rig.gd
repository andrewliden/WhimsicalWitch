extends Spatial

###Constants###
const MOVE_BOX = Vector3(20, 11.25, 0)
###Variables###
var motionVector = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	motionVector = $witch_base.get_motion_vector()
	clamp_to_box()
	move()

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
