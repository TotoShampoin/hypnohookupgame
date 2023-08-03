extends FolkBehavior
class_name FB_Brat

var time: float = 0


func can_spawn(_parent: Folk, _player: Player, _others: Array[Node], _distance: float):
	return true

func react(_this: Folk, _player: Player, _others: Array[Node], _distance: float, delta: float):
	time += delta * 8
	var ground_diretion = -Vector2.from_angle(cos(time) * PI / 2)
	set_target(Vector3(ground_diretion.x, 0, ground_diretion.y))
	set_speed(6)
	set_snap(false)
