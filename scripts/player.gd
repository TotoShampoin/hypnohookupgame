extends CharacterBody3D
class_name Player

@export var WALK_SPEED: float = 0.65
@export var STRAFE: float = 3
@export var STRAFE_TIME: float = .075
@export var MAX_HEALTH: float = 10

@onready var health = MAX_HEALTH

var walk_target = Vector3.ZERO

var targets: Array[CharacterBody3D] = []

signal walk(speed, delta)


func _input(event):
	if health == 0:
		return
	if event.is_action_pressed("snap"):
		for folk in targets:
			folk.get_hypnotized()
		$Snap/Sprite.show()
		$Snap/Sprite.play("snap")

func _process(_delta):
	walk_target.z = Input.get_axis("up", "down")
	if not $Snap/Sprite.is_playing():
		$Snap/Sprite.hide()

func _physics_process(delta):
	var speed = health / MAX_HEALTH
	velocity = velocity.move_toward(walk_target * STRAFE * speed, delta / STRAFE_TIME * speed)
	if speed == 0:
		velocity = Vector3.ZERO
	var walk_speed = WALK_SPEED * speed
	emit_signal("walk", walk_speed, delta)
	move_and_slide()


func on_hypnotized(amount):
	health = move_toward(health, 0, amount)

func get_mesmerized_level():
	return 1 - health / MAX_HEALTH



func _on_snap_body_entered(body:Node3D):
	if body.is_in_group("folks"):
		targets.append(body)

func _on_snap_body_exited(body:Node3D):
	if body.is_in_group("folks"):
		targets.erase(body)


