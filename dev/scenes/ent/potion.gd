extends RigidBody


var explosion

# Called when the node enters the scene tree for the first time.
func _ready():
	explosion = preload("res://scenes/ent/potion_explosion.tscn")
	var throwForce = transform.basis.z * 40 + transform.basis.y * 10
	apply_impulse(Vector3(0.1,1,0), throwForce)
	add_to_group("projectiles")
	add_to_group("potions")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#the potion will explode if the user right clicks again, or it hits an object
	if Input.is_action_just_pressed("gameplay_alt_fire"):
		explode()
	var collisions = get_colliding_bodies()
	if collisions.size() > 0:
		explode()

func explode():
	var explosionInstance = explosion.instance()
	get_tree().get_root().add_child(explosionInstance)
	explosionInstance.global_transform = global_transform
	queue_free()

#The timer expiring also causes the potion to explode.
func _on_DestroyTimer_timeout():
	explode()
