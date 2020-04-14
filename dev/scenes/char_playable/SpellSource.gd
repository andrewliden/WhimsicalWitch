extends Spatial

var splittingMissile
var magicMissile
var potion
var numPotions = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	magicMissile = preload("res://scenes/ent/MagicMissile.tscn")
	potion = preload("res://scenes/ent/potion.tscn")
	splittingMissile = preload("res://scenes/ent/SplittingMagicMissile.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("gameplay_fire"):
		create_projectile(splittingMissile)
	if Input.is_action_just_pressed("gameplay_alt_fire"):
		if get_tree().get_nodes_in_group("potions").size() == 0:
			if numPotions > 0:
				create_projectile(potion)
				numPotions -= 1
		
func create_projectile(type):
	var projectileInstance = type.instance()
	get_tree().get_root().add_child(projectileInstance)
	projectileInstance.global_transform = global_transform
	play_attack_anim()
	
func play_attack_anim():
	var animPlayer = get_parent().get_node("AnimationPlayer")
	animPlayer.stop()
	animPlayer.queue("SpellCast")
	animPlayer.queue("Flying")
	animPlayer.play()
