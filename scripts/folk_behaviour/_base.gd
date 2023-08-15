extends Resource
class_name FolkBehavior

@export var sprites: SpriteFrames

var target: Vector3
var speed: float

var can_snap: bool = true


func _ready():
	for name in ["walk", "hypno"]:
		if not sprites.has_animation(name):
			push_error("%s animation missing in %s" % [name, self.get_class()])


func set_speed(new_speed: float):
	speed = new_speed

func set_target(new_target: Vector3):
	target = new_target

func set_snap(can: bool):
	can_snap = can

func goto_target(parent: Folk):
	parent.walk_direction = target.normalized()
	parent.walk_speed = speed

func can_spawn(_parent: Folk, _player: Player, _others: Array[Node], _distance: float):
	return true

func on_spawn(_parent: Folk, _player: Player, _others: Array[Node], _distance: float):
	pass

func react(_parent: Folk, _player: Player, _others: Array[Node], _distance: float, _delta: float):
	pass

