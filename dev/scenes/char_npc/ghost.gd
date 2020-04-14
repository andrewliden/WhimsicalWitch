extends KinematicBody

const MOVE_SPEED = 20
const POINT_VALUE = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemies")

func _physics_process(delta):
	if get_parent().get("offset") != null:
		get_parent().offset += MOVE_SPEED * delta

func _on_AnimationPlayer_animation_finished(anim_name):
	#If the "surprise" animation just finished, this ghost was just banished.
	if anim_name == "Surprise":
		queue_free()

func is_hit_by(_node):
	if $AnimationPlayer.current_animation == "Float":
		global.score += POINT_VALUE
		$AnimationPlayer.stop()
		$AnimationPlayer.queue("Surprise")
		$AnimationPlayer.play()
