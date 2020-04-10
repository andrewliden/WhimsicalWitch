extends RigidBody


const THROW_FORCE = Vector3(0, 10, 40)


# Called when the node enters the scene tree for the first time.
func _ready():
	apply_impulse(Vector3(0.1,1,0), THROW_FORCE)
	add_to_group("projectiles")
	add_to_group("potions")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#the potion will explode if the user right clicks again, or it hits an object
	if Input.is_action_just_pressed("gameplay_alt_fire"):
		explode()
	var collisions = get_colliding_bodies()
	if collisions.size() > 0:
		explode()

func explode():
	print("The potion would have just exploded")
	queue_free()

#The timer expiring also causes the potion to explode.
func _on_DestroyTimer_timeout():
	explode()
