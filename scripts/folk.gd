extends CharacterBody3D

enum SubbinessLevel {
	COLANDER,
	SUBMISSIVE,
	ADJUSTING,
	OVERTHINKER,
	BRICK_WALL,
}

signal snap()

@export var subbiness: SubbinessLevel = SubbinessLevel.SUBMISSIVE

var is_hypnotized = false
var has_snapped = false

var ground_speed = Vector3.ZERO
var walk_speed = Vector3(-1.5, 0, 0)

func _process(delta):
	if not $Snap/Sprite.is_playing():
		$Snap/Sprite.hide()

func _physics_process(delta):
	if not is_hypnotized:
		velocity = walk_speed
	else:
		velocity = Vector3.ZERO
	move_and_slide()

func forward(delta):
	position.x -= delta * 2

func start_at(at: Vector3):
	position = at

func get_hypnotized():
	if has_snapped:
		return
	is_hypnotized = true


func _on_area_3d_body_entered(body:Node3D):
	if is_hypnotized:
		return
	if body.is_in_group("player"):
		emit_signal("snap")
		$Snap/Sprite.show()
		$Snap/Sprite.play("snap")
		has_snapped = true
