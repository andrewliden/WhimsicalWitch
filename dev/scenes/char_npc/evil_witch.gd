extends KinematicBody

const speed = 50
const gravity = Vector3(0,-25,0)
const walkDist = 100
const attackDist = 80
const predictAmount = 0.1
const timeVariance = 0.05
var spell
var canAttack = true
var dist = INF

# Called when the node enters the scene tree for the first time.
func _ready():
	spell = preload("res://EvilMagicMissile.tscn")
	#Add a little variance to the attack timer's time length.
	$AttackTimer.wait_time *= rand_range(1 - timeVariance, 1 + timeVariance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Get the distance to the player, if you can.
	var player = globalVars.get_player_node()
	if player:
		dist = player.get_dist(self)
		#If there's a player to attack, try to attack them.
		attack_check()
	var motion = Vector3(0,0,0)
	if dist <= walkDist:
		motion = transform.basis.z * speed
	motion += gravity
	move_and_collide(motion * delta)
	
	
func attack_check():
	if canAttack:
		var target = globalVars.get_player_node().get_node("Witch")
		#Don't try to attack from behind.  That's cheeky.
		if target.global_transform.origin.z < global_transform.origin.z:
			#Figure out how far away the target is.
			if dist <= attackDist:
				attack(dist)

func attack(dist):
	var target = globalVars.playerNode.get_node("Witch")
	var targetPos = target.global_transform.origin + Vector3(0,0,predictAmount * dist)
	$SpellSource.look_at(targetPos, Vector3(0,1,0))
	var spellInstance = spell.instance()
	#$SpellSource.add_child(spellInstance)
	get_parent().add_child(spellInstance)
	spellInstance.global_transform.origin = $SpellSource.global_transform.origin
	spellInstance.global_transform.basis = $SpellSource.global_transform.basis	
	
	canAttack = false
	$AttackTimer.start()
	
func _on_AttackTimer_timeout():
	canAttack = true

func damage():
	#On damage, just increase the player's score and remove this from the queue.
	globalVars.score += 100
	queue_free()
