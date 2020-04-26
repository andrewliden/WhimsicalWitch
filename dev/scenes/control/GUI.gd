extends Control


# Declare member variables here. Examples:
var healthbar
var boostbar
var scoreDisplay


# Called when the node enters the scene tree for the first time.
func _ready():
	healthbar = $HealthContainerMargin/HealthContainerGroup/HealthBar
	boostbar = $BoostContainerMargin/BoostContainerGroup/BoostBar
	scoreDisplay = $ScoreContainerMargin/Score/ScoreLabelValue

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#Automatically update the score.
	scoreDisplay.text = str(global.score)

func set_health(amount):
	healthbar.value = amount

func set_boost(amount):
	boostbar.value = amount

func toggle_raspberry_jam(onoff):
	if onoff:
		if !$RaspberryJam.visible:
			$RaspberryJamAnimations.queue("Injure_effect_fadeIn")
			$RaspberryJamAnimations.play()
	else:
		if $RaspberryJam.visible:
			$RaspberryJamAnimations.queue("Injure_effect_fadeOut")
			$RaspberryJamAnimations.play()
	
func set_bombs(amount):
	$BoostContainerMargin/BoostContainerGroup/BombsGroup/numBombsLabel.text = str(amount)
