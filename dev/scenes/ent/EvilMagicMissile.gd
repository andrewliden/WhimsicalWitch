extends Area


var speed = -100

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("projectiles")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector3(0,0,speed * delta))

func deflect():
	speed = abs(speed)

func _on_DestroyTimer_timeout():
	queue_free()

func is_hit_by(_target):
	queue_free()


func _on_MagicMissile_body_entered(body):
	if(body.is_in_group("player")):
		if body.spinning:
			deflect()
		else:
			body.damage_player()
	is_hit_by(body)
