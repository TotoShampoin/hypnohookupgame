extends FolkBehavior
class_name FB_Normal

func can_spawn(_parent: Folk, _player: Player, _others: Array[Node], _distance: float):
	return true

func on_spawn(_parent: Folk, _player: Player, _others: Array[Node], _distance: float):
	set_target(Vector3(-1,0,0))
	set_speed(1)
	set_snap(true)

func react(_this: Folk, _player: Player, _others: Array[Node], _distance: float, _delta: float):
	pass

