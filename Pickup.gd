extends Area

enum PickupType {
	Health,
	Ammo
}

export (PickupType) var type = PickupType.Health
export var amount := 10

onready var startYPos : float = translation.y
var bobHeight := 1.0
var bobSpeed := 1.0
var bobbingUp := true

func _process(delta):
	translation.y += (bobSpeed if bobbingUp == true else -bobSpeed) * delta

	if bobbingUp and translation.y > startYPos + bobHeight:
		bobbingUp = false
	elif !bobbingUp and translation.y < startYPos:
		bobbingUp = true

func _on_Pickup_body_entered(body):
	if body.name == "Player":
		pickup(body)
		queue_free()

func pickup (player):
	if type == PickupType.Health:
		player.add_health(amount)
	elif type == PickupType.Ammo:
		player.add_ammo(amount)
