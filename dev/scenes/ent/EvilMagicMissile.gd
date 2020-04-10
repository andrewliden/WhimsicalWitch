extends KinematicBody


var speed = -100

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("projectiles")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(transform.basis.z * speed * delta)
	if collision:
		var target = collision.get_collider()
		if target.is_in_group("player"):
			if target.spinning:
				deflect()
			else:
				target.damage_player()
				destroy_self()
		else:
			destroy_self()

func deflect():
	speed = abs(speed)

func _on_DestroyTimer_timeout():
	queue_free()

func destroy_self():
	queue_free()
