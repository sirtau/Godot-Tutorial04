extends Control

onready var healthBar := $HealthBar
onready var ammoText := $AmmoText
onready var scoreText := $ScoreText

func update_health_bar (curHp, maxHp):
	healthBar.max_value = maxHp
	healthBar.value = curHp
	
func update_ammo_text (ammo):
	ammoText.text = "Ammo: " + str(ammo)

func update_score_text (score):
	scoreText.text = "Score: " + str(score)
