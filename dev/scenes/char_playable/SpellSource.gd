extends Spatial

var magicMissile

# Called when the node enters the scene tree for the first time.
func _ready():
	magicMissile = preload("res://scenes/ent/MagicMissile.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("gameplay_fire"):
		var missileInstance = magicMissile.instance()
		get_tree().get_root().add_child(missileInstance)
		missileInstance.global_transform = global_transform
		var animPlayer = get_parent().get_node("AnimationPlayer")
		animPlayer.stop()
		animPlayer.queue("SpellCast")
		animPlayer.queue("Flying")
		animPlayer.play()
