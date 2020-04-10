extends Spatial

const CAMERA_TRACK_STRENGTH = 0.5

var trackSpeed = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	track_witch()
	follow_path(delta)

func track_witch():
	$Camera.translation.x = $witch_move_rig.translation.x * CAMERA_TRACK_STRENGTH
	$Camera.translation.y = $witch_move_rig.translation.y * CAMERA_TRACK_STRENGTH

func follow_path(delta):
	#If the offset attribute exists on the parent, follow the path
	if get_parent().offset != null:
		get_parent().offset += trackSpeed * delta
