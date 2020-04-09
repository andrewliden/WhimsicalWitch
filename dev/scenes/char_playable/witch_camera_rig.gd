extends Spatial

const CAMERA_TRACK_STRENGTH = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	track_witch()
	
func track_witch():
	$Camera.translation.x = $witch_move_rig.translation.x * CAMERA_TRACK_STRENGTH
	$Camera.translation.y = $witch_move_rig.translation.y * CAMERA_TRACK_STRENGTH
