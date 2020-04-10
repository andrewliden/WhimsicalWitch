extends Spatial

const CAMERA_TRACK_STRENGTH = 0.5
const SLOW_FOV = 50
const BOOST_FOV = 90
const DEFAULT_FOV = 70
const BOOST_AMOUNT = 5
const SHAKE_AMOUNT = 1

var trackSpeed = 10
var boost = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	track_witch()
	check_boost_input()
	follow_path(delta)
	adjustFOV()
	if $witch_move_rig/witch_base.takingDamage:
		shakeCam(delta)
	else:
		$Camera.set_rotation_degrees(Vector3(0,180,0))

func track_witch():
	$Camera.translation.x = $witch_move_rig.translation.x * CAMERA_TRACK_STRENGTH
	$Camera.translation.y = $witch_move_rig.translation.y * CAMERA_TRACK_STRENGTH

func check_boost_input():
	if boost == 0:
		if Input.is_action_pressed("gameplay_up"):
			$BoostTimer.start()
			boost = 1
		elif Input.is_action_pressed("gameplay_down"):
			$BoostTimer.start()
			boost = -1

func follow_path(delta):
	#If the offset attribute exists on the parent, follow the path
	if get_parent().offset != null:
		get_parent().offset += (trackSpeed + boost * BOOST_AMOUNT) * delta

func _on_BoostTimer_timeout():
	boost = 0

func adjustFOV():
	if boost != 0:
		var targetFOV = BOOST_FOV
		if boost < 0:
			targetFOV = SLOW_FOV
		var boostTimePercent = $BoostTimer.time_left / $BoostTimer.wait_time
		#During the first 10% of the boost, ease in to the target FOV
		if boostTimePercent >= 0.9:
			var weight = (1 - boostTimePercent) / 0.1
			$Camera.fov = lerp(DEFAULT_FOV, targetFOV, weight)
		if boostTimePercent <= 0.25:
			var weight = (0.25 - boostTimePercent)  * 4
			#print(weight)
			$Camera.fov = lerp(targetFOV, DEFAULT_FOV, weight)
	else:
		$Camera.fov = 70

func shakeCam(delta):
	$Camera.rotate_z(rand_range(-SHAKE_AMOUNT, SHAKE_AMOUNT) * delta)

#Retrieves how much percent of your boost is left
func get_boost():
	return 1 - $BoostTimer.time_left / $BoostTimer.wait_time

func get_health():
	return $witch_move_rig/witch_base.health
