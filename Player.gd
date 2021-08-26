extends KinematicBody

export var curHp := 10
export var maxHp:= 10
export var ammo:= 10
export var score:= 0
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
export var BulletScene : PackedScene 
onready var ui : Node = get_node("/root/MainScene/CanvasLayer/UI")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	ui.update_health_bar(curHp, maxHp)
	ui.update_score_text(score)
	ui.update_ammo_text(ammo)

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

func _process(delta):
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	
	mouseDelta = Vector2()
	if Input.is_action_just_pressed("attack") and ammo > 0:
		shoot()

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func take_damage(damage):
	curHp -= damage
	ui.update_health_bar(curHp, maxHp)
	if curHp < 0:	
		die()

func die():
	print('you dead~')
	
func add_score (amount):
	score+= amount
	ui.update_score_text(score)
	
func shoot ():
	var bullet = BulletScene.instance()
	get_node("/root/MainScene").add_child(bullet)
	ui.update_ammo_text(ammo)
	bullet.global_transform = muzzle.global_transform
	
	ammo -= 1

func add_health (amount):
	
	curHp += amount
	
	if curHp > maxHp:
		curHp = maxHp
	ui.update_health_bar(curHp, maxHp)

func add_ammo (amount):
	
	ammo += amount
	ui.update_ammo_text(ammo)
