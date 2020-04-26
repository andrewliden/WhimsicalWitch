extends Spatial

const gravity = Vector3(0,-25,0)
const moveSpeed = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Build a "steering force"
	#First, you want the ent to always try to look at the indicator.
	var lookIndicatorPos = $Path/PathFollow/Look.global_transform.origin
	#I don't want the ent to care about looking upwards.
	lookIndicatorPos.y = $ent.global_transform.origin.y
	$ent.look_at(lookIndicatorPos, Vector3(0,1,0))
	#By default, look_at seems to point opposite the way I want.
	#Easily fixed, though.  Just rotate an additional pi radians.
	$ent.rotate_y(PI)
	var dist = $ent.global_transform.origin.distance_to(lookIndicatorPos)
	var motionVector = $ent.global_transform.basis.z * delta * dist * moveSpeed
	motionVector += gravity * delta
	$ent.move_and_collide(motionVector)


func _on_ent_tree_exited():
	queue_free()
