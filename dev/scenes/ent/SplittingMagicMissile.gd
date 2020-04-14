extends Area


const speed = 100
var explosion
var missile


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("projectiles")
	missile = preload("res://scenes/ent/MagicMissile.tscn")
	explosion = preload("res://scenes/ent/explosion.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector3(0,0,speed * delta))

func _on_DestroyTimer_timeout():
	split()

func split():
	#create 3 missiles
	var forwardMissile = missile.instance()
	var rightMissile = missile.instance()
	var leftMissile = missile.instance()
	var root = get_tree().get_root()
	#Add the missiles at the root and copy the transforms from the sources.
	root.add_child(forwardMissile)
	forwardMissile.global_transform = $ForwardMissileSource.global_transform
	root.add_child(rightMissile)
	rightMissile.global_transform = $RightMissileSource.global_transform
	root.add_child(leftMissile)
	leftMissile.global_transform = $LeftMissileSource.global_transform
	#get rid of this source missile
	queue_free()

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
	if body.is_in_group("enemies"):
		if body.has_method("is_hit_by"):
			body.is_hit_by(self)
	destroy_self()
