extends KinematicBody

var health = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemies")


func is_hit_by(_body):
	health -= 1
	if health <= 0:
		queue_free()
