extends KinematicBody

const SPEED = 40
const GRAVITY = Vector3(0,-25,0)
const WALK_DIST = 100
const ATTACK_DIST = 80
const PREDICT_AMOUNT = 0.2
const TIME_VARIANCE = 0.05
var spell
var canAttack = true
var playerPos = Vector3(0,0,0)
var playerFwd = Vector3(0,0,0)
var dist = INF

# Called when the node enters the scene tree for the first time.
func _ready():
	spell = preload("res://scenes/ent/EvilMagicMissile.tscn")
	#Add a little variance to the attack timer's time length.
	add_to_group("enemies")
	$AttackTimer.wait_time *= rand_range(1 - TIME_VARIANCE, 1 + TIME_VARIANCE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Get the distance to the player
	dist = global_transform.origin.distance_to(playerPos)
	attack_check()
	var motion = Vector3(0,0,0)
	if dist <= WALK_DIST:
		motion = transform.basis.z * SPEED
	motion += GRAVITY
	move_and_collide(motion * delta)
	
	
func attack_check():
	if canAttack:
		#Make sure the player is in front of you, not behind you.
		#Attacking from your back seems...weird.
		var localPlayerPos = to_local(playerPos)
		if localPlayerPos.z > 0:
			#Figure out how far away the target is.
			if dist <= ATTACK_DIST:
				attack(dist)

func attack(dist):
	var targetPos = playerPos + playerFwd * PREDICT_AMOUNT
	$SpellSource.look_at(targetPos, Vector3(0,1,0))
	var spellInstance = spell.instance()
	#$SpellSource.add_child(spellInstance)
	get_parent().add_child(spellInstance)
	spellInstance.global_transform = $SpellSource.global_transform
	
	canAttack = false
	$AttackTimer.start()
	
func _on_AttackTimer_timeout():
	canAttack = true

func damage():
	#On damage, just increase the player's score and remove this from the queue.
	global.score += 100
	queue_free()
	
func update_player_position(positionVector):
	playerPos = positionVector

func update_player_forward_dir(basisZvector):
	playerFwd = basisZvector
