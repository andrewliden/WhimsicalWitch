extends KinematicBody


const speed = 100
var explosion


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("projectiles")
	explosion = preload("res://scenes/ent/explosion.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(transform.basis.z * speed * delta)
	if collision:
		var collider = collision.get_collider()
		#Have collision management with enemies handled by the enemy.
		if collider.is_in_group("enemies"):
			collider.is_hit_by(self)
		destroy_self()

func _on_DestroyTimer_timeout():
	destroy_self()

func destroy_self():
	#create an explosion, put it at the root
	var explosionInstance = explosion.instance()
	get_parent().add_child(explosionInstance)
	#copy the position from this item to the explosion
	explosionInstance.global_transform.origin = self.global_transform.origin
	queue_free()
	
func is_hit_by(node):
	destroy_self()
