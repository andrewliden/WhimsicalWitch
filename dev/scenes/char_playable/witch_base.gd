extends KinematicBody

###Constants###
const MOUSE_SENSITIVITY = 0.25
const MAX_SPEED = 50
const NUDGE_AMOUNT = 0.175
const POINT_FWD_SPEED = 10
const ROTATE_THRESHOLD = 0.1
const SPIN_SPEED = 20
const TILT_SPEED = 10
const MAX_HEALTH = 100
const SHAKE_AMOUNT = 15

###Variables###
var motionVector = Vector3()
var forwardVector = Vector3()
var aboveVector = Vector3()
var leftVector = Vector3()
var rotatedRight = false
var rotatedLeft = false
var spinning = false
var takingDamage = false
var health = MAX_HEALTH

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_parent_basis()
	clamp_motion_speed(delta)
	apply_nudge(delta)
	handle_tilt(delta)
	point_forwards(delta)
	collision_check()
	check_mouse_unlock()

func _input(event):
	if event is InputEventMouseMotion:
		mouse_movement(event)

func mouse_movement(event):
	#Get a motion vector from the mouse
	motionVector = Vector3(event.relative.x, event.relative.y, 0) * - MOUSE_SENSITIVITY

#Gets the parent node and uses it as a reference for the meaning of "forward", "above" and "right"
#This matters, because we're planning on rotating our prop, but we don't want the plane of
#movement to rotate along with it.
func get_parent_basis():
	var parent = get_parent()
	forwardVector = parent.transform.basis.z
	aboveVector = parent.transform.basis.y
	leftVector = parent.transform.basis.x

#Clamps the motion speed to a maximum value.  Also takes care of applying delta to the motion speed.
func clamp_motion_speed(delta):
	motionVector *= delta
	if motionVector.length() > MAX_SPEED * delta:
		motionVector = motionVector.normalized() * MAX_SPEED * delta

func apply_nudge(delta):
	#I saw a tutorial that uses a guide that the player looks at instead of this approach.
	#after this project is done, I might experiment with that.  This seems to work alright, though.
	
	#When the player moves the mouse, rotate the model in an axis orthogonal to the direction of movement,
	#And within the 2D plane of the player's movement (that is, we're ignoring Z)
	var nudgeVector = Vector3(motionVector.y * -1, motionVector.x, 0) * NUDGE_AMOUNT
	rotate_x(nudgeVector.x)
	rotate_y(nudgeVector.y)
	#If the player is taking damage, also randomly nudge the player.
	if takingDamage:
		rotate_x(rand_range(-SHAKE_AMOUNT, SHAKE_AMOUNT) * delta)
		rotate_y(rand_range(-SHAKE_AMOUNT, SHAKE_AMOUNT) * delta)

func handle_tilt(delta):
	if rotatedLeft and Input.is_action_just_pressed("gameplay_left"):
		start_spin()
		
	if rotatedRight and Input.is_action_just_pressed("gameplay_right"):
		start_spin()
	
	if spinning:
		if rotatedRight:
			rotate_z(SPIN_SPEED * delta)
		else:
			rotate_z(-SPIN_SPEED * delta)
	elif Input.is_action_pressed("gameplay_left") and !rotatedRight:
		rotatedLeft = true
		var zDot = aboveVector.dot(transform.basis.y * -1)
		rotate_z(zDot * delta * TILT_SPEED)
	elif Input.is_action_pressed("gameplay_right") and !rotatedLeft:
		rotatedRight = true
		var zDot = aboveVector.dot(transform.basis.y * 1)
		rotate_z(zDot * delta * TILT_SPEED)
	else:
		#If you're not doing a spin or tilt, rotate z so that y is orthogonal to the left vector again
		var zDot = leftVector.dot(transform.basis.y)
		rotate_z(zDot * delta * TILT_SPEED)
		#If the dot product is greater than the negative threshold, we're not rotated right anymore.
		#If it's less than the positive threshold, we're not rotated left anymore.
		if(zDot > -ROTATE_THRESHOLD):
			rotatedRight = false
		if(zDot < ROTATE_THRESHOLD):
			rotatedLeft = false

func start_spin():
	if !spinning:
		$SpinTimer.start()
		spinning = true

func point_forwards(delta):
	#rotate along the y axis until z is orthogonal to the left again.
	var xDot = leftVector.dot(transform.basis.z)
	rotate_y(xDot * delta * POINT_FWD_SPEED * -1)
	#rotate along the x axis until z is orthogonal to the above again.
	var yDot = aboveVector.dot(transform.basis.z)
	rotate_x(yDot * delta * POINT_FWD_SPEED)

func get_motion_vector():
	return motionVector
	
func collision_check():
	var collision = move_and_collide(Vector3(0,0,0), false, true, true)
	if collision:
		var collider = collision.get_collider()
		if collider.is_in_group("pickup") or collider.is_in_group("projectiles"):
			#Projectiles and pickups will perform their own collision checking.
			pass
		elif collider.is_in_group("enemies"):
			damage_player()
			if collider.has_method("is_hit_by"):
				collider.is_hit_by(self)
		else:
			damage_player()
		
func check_mouse_unlock():
	#This function checks for the ui cancel input.
	#if it gets it, the mouse mode is toggled between visible and captured.
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func is_hit_by(_node):
	damage_player()

func damage_player(amount = 10):
	if !takingDamage:
		takingDamage = true
		$DamageTimer.start()
		health -= amount

func _on_SpinTimer_timeout():
	spinning = false

func _on_DamageTimer_timeout():
	takingDamage = false

func get_spell_powerup():
	$SpellSource.splitShot = true

func get_health_pickup():
	health += 25
	if health > MAX_HEALTH:
		health = MAX_HEALTH
