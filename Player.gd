extends KinematicBody

export var curHp := 10
export var maxHP:= 10
export var ammo:= 15
export var score:= 15
export var gold:= 0

export var moveSpeed := 5.0
export var jumpForce := 5.0
export var gravity := 12.0

var minLookAngle := -88.0
var maxLookAngle := 88.0
export var lookSensitivity := 10.0

var vel := Vector3()
var mouseDelta:= Vector2()

onready var camera := $Camera
onready var muzzle := $Camera/Muzzle

func _physics_process(delta):
	vel.x = 0
	vel.z = 0
	var input = Vector2()
	
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_back"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
	input = input.normalized()
	
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	var relativeDir = (forward * input.y + right * input.x)
	
	vel.x = relativeDir.x * moveSpeed
	vel.z = relativeDir.z * moveSpeed
	
	vel.y -= gravity * delta
	
	vel = move_and_slide(vel, Vector3.UP)

	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jumpForce
