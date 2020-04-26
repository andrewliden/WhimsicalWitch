extends Area


const speed = 100
var explosion


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("projectiles")
	explosion = preload("res://scenes/ent/explosion.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector3(0,0,speed * delta))

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


func _on_MagicMissile_body_entered(body):
	hit(body)
	
func hit(object):
	if object.is_in_group("enemies"):
		if object.has_method("is_hit_by"):
			object.is_hit_by(self)
	destroy_self()


func _on_MagicMissile_area_entered(area):
	pass
