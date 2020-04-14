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
		#If you hit anything other than the player, just destroy the projectile.
		#If you hit the player, the collision will be handled by them so deflection can happen.
		if !target.is_in_group("player"):
			is_hit_by(target)

func deflect():
	speed = abs(speed)

func _on_DestroyTimer_timeout():
	queue_free()

func is_hit_by(target):
	queue_free()
