extends Area

export var speed := 30.0
export var damage := 1

func _process(delta):
	translation += global_transform.basis.z * speed * delta
	
func destroy ():
	queue_free()
	


func _on_Bullet_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		destroy()
