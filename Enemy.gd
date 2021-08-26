extends KinematicBody

export var curHp := 5
export var maxHP:= 5
export var moveSpeed := 2.0

export var damage := 1
export var attackRate := 1.0
export var attackDist := 4.0

var scoreToGive := 10

onready var player : Node = get_node("/root/MainScene/Player")
onready var timer : Timer = $Timer

func _ready():
	timer.set_wait_time(attackRate)
	timer.start()
	
func _physics_process(delta):
	var dir = (player.translation - translation).normalized()
	dir.y = 0
	if translation.distance_to(player.translation) > attackDist:
		move_and_slide(dir * moveSpeed, Vector3.UP)
	
	
func attack():
	player.take_damage(damage)
	
func _on_Timer_timeout():
	if translation.distance_to(player.translation) <= attackDist:
		attack()

func take_damage(damage):
	curHp -= damage
	if curHp < 0:
		die()

func die():
	player.add_score(scoreToGive)
	queue_free()
