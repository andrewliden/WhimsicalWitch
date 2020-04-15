extends KinematicBody

const MOVE_SPEED = 20
const TIMER_VARIANCE_MUL = 0.1
const PREDICT_AMOUNT = 0.2

var canShoot = false
var playerDetected = false
var player
var donutAttack

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemies")
	#Add some random variance on the shoot timer.
	var timerVariance = 1 + rand_range(-TIMER_VARIANCE_MUL, TIMER_VARIANCE_MUL)
	$ShootTimer.wait_time *= timerVariance
	donutAttack = preload("res://scenes/ent/donut_attack.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#If you haven't detected the player yet, just sit still.
	if playerDetected:
		move(delta)
		if canShoot:
			aim()

func move(delta):
	#If you have a path to follow, use it.
	if get_parent().get("offset") != null:
		get_parent().offset += MOVE_SPEED * delta
	else:
		#otherwise, just move forward.
		translate(Vector3(0,0,MOVE_SPEED * delta))

func aim():
	#Aim a little bit in front of the player.
	var targetPos = player.global_transform.origin
	targetPos += player.transform.basis.z * PREDICT_AMOUNT
	$BulletSource.look_at(targetPos, Vector3(0,1,0))

func is_hit_by(_node):
	queue_free()

func _on_ShootArea_body_entered(body):
	if body.is_in_group("player"):
		canShoot = true

func _on_ShootArea_body_exited(body):
	if body.is_in_group("player"):
		canShoot = false

func _on_PlayerDetectionArea_body_entered(body):
	if body.is_in_group("player"):
		playerDetected = true
		player = body

func _on_PlayerDetectionArea_body_exited(body):
	if body.is_in_group("player"):
		playerDetected = false

func _on_ShootTimer_timeout():
	if canShoot:
		shoot()

func shoot():
	var attack = donutAttack.instance()
	get_tree().get_root().add_child(attack)
	attack.global_transform = $BulletSource.global_transform
	
