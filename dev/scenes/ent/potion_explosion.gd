extends KinematicBody

const MAX_SCALE = 40
const MIN_SCALE = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector3(1, 1, 1) * MIN_SCALE
	add_to_group("projectiles")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !$GrowTime.is_stopped():
		grow()
	else:
		shrink()
	
func grow():
	var timerPercent = 1 - $GrowTime.time_left / $GrowTime.wait_time
	var targetScale = smoothstep(0, 1, timerPercent) * MAX_SCALE
	scale = Vector3(1, 1, 1) * targetScale

func shrink():
	var timerPercent = 1 - $ShrinkTime.time_left / $ShrinkTime.wait_time
	var targetScale = smoothstep(1, 0, timerPercent) * MAX_SCALE
	scale = Vector3(1, 1, 1) * targetScale

func _on_GrowTime_timeout():
	$ShrinkTime.start()

func _on_ShrinkTime_timeout():
	queue_free()
