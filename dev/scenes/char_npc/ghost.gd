extends KinematicBody

const MOVE_SPEED = 2;

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemies")

func _physics_process(delta):
	if get_parent().get("offset") != null:
		get_parent().offset += MOVE_SPEED * delta
	collision_check()

func _on_AnimationPlayer_animation_finished(anim_name):
	#If the "surprise" animation just finished, this ghost was just banished.
	#remove it from the queue and add to the player's score.
	if anim_name == "Surprise":
		#globalVars.score += 200
		queue_free()

func collision_check():
	var collision = move_and_collide(Vector3(0,0,0), true, true, true)
	if collision:
		damage()

func damage():
	if $AnimationPlayer.current_animation == "Float":
		$AnimationPlayer.stop()
		$AnimationPlayer.queue("Surprise")
		$AnimationPlayer.play()
