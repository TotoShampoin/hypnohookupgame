extends CharacterBody3D
class_name Player

@export var WALK_SPEED: float = 0.65
@export var STRAFE: float = 4
@export var STRAFE_TIME: float = .075
@export var MAX_HEALTH: float = 4
@export var RECOVERY: float = 1.5

@onready var health = MAX_HEALTH

var walk_target = Vector3.ZERO
var recovering = 0

var targets: Array[CharacterBody3D] = []

signal walk(speed, delta)


func _input(event):
	if health == 0:
		return
	if recovering > 0:
		return
	if event.is_action_pressed("snap"):
		for folk in targets:
			folk.get_hypnotized()
		$Snap/Sprite.show()
		$Snap/Sprite.play("snap")

func _process(delta):
	walk_target.x = Input.get_axis("left", "right")
	walk_target.z = Input.get_axis("up", "down")
	if not $Snap/Sprite.is_playing():
		$Snap/Sprite.hide()
	if recovering > 0:
		$Snap.hide()
	else:
		$Snap.show()
	
	recovering -= delta

func _physics_process(delta):
	var speed = health / MAX_HEALTH
	var strafe_speed = speed
	if recovering > 0:
		strafe_speed /= 2
	velocity = velocity.move_toward(walk_target * STRAFE * strafe_speed, delta / STRAFE_TIME * strafe_speed)
	if speed == 0:
		velocity = Vector3.ZERO
	var walk_speed = WALK_SPEED * speed
	emit_signal("walk", walk_speed, delta)
	move_and_slide()


func on_hypnotized(amount):
	if health == 0:
		return true
	health = move_toward(health, 0, amount)
	if recovering > 0:
		return false
	recovering = RECOVERY
	return true

func get_mesmerized_level():
	return 1 - health / MAX_HEALTH

func get_speed():
	return health / MAX_HEALTH


func _on_snap_body_entered(body:Node3D):
	if body.is_in_group("folks"):
		targets.append(body)

func _on_snap_body_exited(body:Node3D):
	if body.is_in_group("folks"):
		targets.erase(body)


func _on_blink_timeout():
	if recovering > 0:
		if visible:
			hide()
		else:
			show()
	else:
		show()
