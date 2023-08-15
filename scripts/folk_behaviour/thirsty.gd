extends FolkBehavior
class_name FB_Thirsty

func can_spawn(_this: Folk, _player: Player, _others: Array[Node], _distance: float):
	return true

func on_spawn(_parent: Folk, _player: Player, _others: Array[Node], _distance: float):
	set_snap(true)

func react(this: Folk, player: Player, _others: Array[Node], _distance: float, _delta: float):
	var dir = this.position.direction_to(player.position)
	if this.has_snapped or this.is_hypnotized:
		set_target(Vector3(-1, 0, 0))
		this.get_node("Sprite").flip_h = true
		set_speed(.5)
	else:
		set_target(dir)
		this.get_node("Sprite").flip_h = (dir.x <= 0)
		if dir.x < 0:
			set_speed(.5)
		else:
			set_speed((speed + (player.get_speed() / 2)) / 2)

