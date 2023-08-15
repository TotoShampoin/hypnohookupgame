extends CharacterBody3D
class_name Folk

var behaviour: FolkBehavior

signal snap(node: Folk)
signal update(node: Folk, delta: float)

var is_hypnotized = false
var has_snapped = false

var ground_speed = Vector3.ZERO
var walk_direction = Vector3(0, 0, 0)
var walk_speed = 0

func _process(_delta):
	if not $Snap/Sprite.is_playing():
		$Snap/Sprite.hide()

func _physics_process(delta):
	emit_signal("update", self, delta)
	behaviour.goto_target(self)
	if not is_hypnotized:
		velocity = walk_direction * walk_speed
	else:
		velocity = Vector3.ZERO
	move_and_slide()

func forward(delta):
	position.x -= delta * 2

func start_at(at: Vector3):
	position = at

func set_behavior(new_behaviour):
	behaviour = new_behaviour.duplicate()
	$Sprite.sprite_frames = behaviour.sprites
	$Sprite.offset.x = -$Sprite.sprite_frames.get_frame_texture("walk", 0).get_width() / 2
	$Sprite.play("walk")

func get_hypnotized():
	if has_snapped:
		return
	is_hypnotized = true
	$Sprite.play("hypno")


func _on_area_3d_body_entered(body:Node3D):
	if is_hypnotized:
		return
	if body.is_in_group("player") and behaviour.can_snap:
		emit_signal("snap", self)
		# $Snap/Sprite.show()
		# $Snap/Sprite.play("snap")
		# has_snapped = true

func apply_snap():
	$Snap/Sprite.show()
	$Snap/Sprite.play("snap")
	has_snapped = true
