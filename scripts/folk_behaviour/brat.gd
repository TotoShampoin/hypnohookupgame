extends FolkBehavior
class_name FB_Brat

@export var PACE_CENTER: float = 8
@export var PACE_RANGE: float = 3

@export var ANGLE_MIN = PI * .25
@export var ANGLE_MAX = PI * .75

@export var SPEED_MIN = 5
@export var SPEED_MAX = 9

var time: float = 0
var pace: float = 0
var angle: float = 0

func can_spawn(_parent: Folk, _player: Player, _others: Array[Node], _distance: float):
	return true

func on_spawn(_parent: Folk, _player: Player, _others: Array[Node], _distance: float):
	set_snap(false)
	set_speed(randf_range(SPEED_MIN, SPEED_MAX))
	time = randf() * PI * 2
	pace = PACE_CENTER + randf_range(-PACE_RANGE/2, PACE_RANGE/2)
	angle = randf_range(ANGLE_MIN, ANGLE_MAX)

func react(_this: Folk, _player: Player, _others: Array[Node], _distance: float, delta: float):
	time += delta * pace
	var ground_diretion = -Vector2.from_angle(cos(time) * angle)
	set_target(Vector3(ground_diretion.x, 0, ground_diretion.y))
