extends Area

var open = false
var openning = false;

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if openning:
		if(get_rotation_degrees().y >= 90):
			open = true
			openning = false
		else:
			rotate_y(delta)
		

func _on_FrontLeftDoor_body_entered(body):
	collision(body)

func _on_FrontLeftDoor_area_entered(area):
	collision(area)

func collision(object):
	if(object.is_in_group("player") or object.is_in_group("projectiles")):
		if !open:
			openning = true
