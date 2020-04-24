extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("pickups")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_potion_body_entered(body):
	if body.is_in_group("player"):
		body.get_health_pickup()
		$PickupSound.play()
		$DestroyTimer.start()
		set_visible(false)


func _on_DestroyTimer_timeout():
	queue_free()
