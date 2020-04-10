extends KinematicBody


const speed = 100
var explosion


# Called when the node enters the scene tree for the first time.
func _ready():
	explosion = preload("res://scenes/ent/explosion.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(transform.basis.z * speed * delta)
	if collision:
		var target = collision.get_collider()
		#If the object you collided with has a damage method, call it.
		if target.has_method("damage"):
			target.damage()
		damage()

func _on_DestroyTimer_timeout():
	damage()

func damage():
	#create an explosion, put it at the root
	var explosionInstance = explosion.instance()
	get_parent().add_child(explosionInstance)
	#copy the position from this item to the explosion
	explosionInstance.global_transform.origin = self.global_transform.origin
	queue_free()
