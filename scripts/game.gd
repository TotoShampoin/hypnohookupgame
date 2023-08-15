extends Control

var spiral: float = 0
var snappy: float = 0

var blink = 0

var text = ""

const PINK  = Color(1,0,1,1)
const WHITE = Color(1,1,1,1)
const TRANSPARENT = Color(0,0,0,0)

const SPLASH = ["TRANCED", "MINDLESS", "OBEDIENT", "LOST", "HYPNOTIZED", "DEEP", "FUZZY", "BRAINWASHED", "VACANT"]

@export var SNAPPY_AMOUNT: float = 1.5

@export var SPIRAL_CURVE: Curve

func _ready():
	pass

func _process(delta):
	var world = $Camera/SubViewport/World
	var zoomy = clamp(inverse_lerp(SNAPPY_AMOUNT - 1, SNAPPY_AMOUNT, snappy), 0, 1)
	var wavy = clamp(remap(snappy, SNAPPY_AMOUNT - 1, SNAPPY_AMOUNT, 0, .05), 0, .05)
	update_offset()
	snappy = move_toward(snappy, 0, delta)
	spiral = SPIRAL_CURVE.sample(world.get_mesmerized_level()) * SNAPPY_AMOUNT
	# world.set_camera_distance(lerp(6, 3, (spiral + 2 * zoomy / (2 * spiral + 1)) / (SNAPPY_AMOUNT)))
	world.set_camera_from_hypno((2 * zoomy) / (SNAPPY_AMOUNT))
	$Spiral.material.set_shader_parameter("show", max(spiral, snappy))
	$Spiral.material.set_shader_parameter("distorsion", clamp(wavy, 0, 0.05))
	
	$Splash/Text.text = ""
	if world.get_mesmerized_level() == 1:
		$Splash/Text.text = text
		world.set_camera_from_hypno(1)
	if blink == 0:
		$Splash/Text.label_settings.font_color = PINK
	else:
		$Splash/Text.label_settings.font_color = TRANSPARENT
	blink = (blink + 1) % 2


func update_offset():
	var world = $Camera/SubViewport/World
	var camera = world.get_viewport().get_camera_3d()
	var absolute_offset = camera.unproject_position(world.get_player_position())
	var offset = absolute_offset / Vector2(world.get_viewport().size)
	$Spiral.material.set_shader_parameter("offset", offset)


func _on_world_snap():
	pass


func _on_world_hypnotized():
	snappy = SNAPPY_AMOUNT


func _on_timer_timeout():
	var old_text = text
	while text == old_text:
		text = SPLASH.pick_random()
