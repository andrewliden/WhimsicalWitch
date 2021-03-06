extends RigidBody

const JUMP_WHEN_DIST_IS = 80
const HIT_FORCE = 20
const POINT_VALUE = 200

var playerDetected = false
var player
var playerGlobalPosition = Vector3(INF, INF, INF)
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemies")

func getPlayerPos():
	playerGlobalPosition = player.global_transform.origin

func _physics_process(_delta):
	if playerDetected:
		getPlayerPos()
		if $JumpTimer.is_stopped():
			if floorCheck():
				$JumpTimer.start()

func floorCheck():
	#Check the raycast and see if there's a collision.
	if $floorChecker.is_colliding():
		#If so, get its class.  If it's a static body,
		#report that the object is on the floor.
		var collider = $floorChecker.get_collider()
		if collider.get_class() == "StaticBody":
			return true
	#If you got here and you didn't return, the object isn't on the floor.
	return false

func hop():
	if floorCheck() and !dead:
		var jumpPower = rand_range(10,25)
		var jumpForce = global_transform.basis.z * jumpPower
		jumpForce += global_transform.basis.y * jumpPower
		apply_impulse(Vector3(0,0,0),jumpForce)
		$AnimationPlayer.queue("JumpStart")
		$AnimationPlayer.play()

func _on_JumpTimer_timeout():
	hop()

func is_hit_by(node):
	if !dead:
		global.score += POINT_VALUE
		dead = true
		set_mode(MODE_RIGID)
		var hitSpot = to_local(node.global_transform.origin)
		var hitImpulse = node.transform.basis.z * HIT_FORCE
		apply_impulse(hitSpot, hitImpulse)
		$RemoveTimer.start()

func _on_RemoveTimer_timeout():
	queue_free()

func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("player"):
		player = body
		playerDetected = true

func _on_PlayerDetector_body_exited(body):
	if body.is_in_group("player"):
		playerDetected = false
