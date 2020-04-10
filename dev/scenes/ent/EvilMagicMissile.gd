extends KinematicBody


var speed = -100
var reflectedMissile

# Called when the node enters the scene tree for the first time.
func _ready():
	#An alternative to putting the projectile in the root:
	#Set as top level makes the object not follow transformations from the parent.
	set_as_toplevel(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(transform.basis.z * speed * delta)
	if collision:
		var target = collision.get_collider()
		if target.has_method("damage"):
			target.damage()
		queue_free()

func deflect():
	speed = abs(speed)

func _on_DestroyTimer_timeout():
	queue_free()
