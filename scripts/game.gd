extends Control

var spiral: float = 0
var snappy: float = 0

@export var SNAPPY_AMOUNT: float = 1.5

@export var SPIRAL_CURVE: Curve

func _ready():
	pass


func _process(delta):
	var world = $Camera/SubViewport/World
	var zoomy = clamp(inverse_lerp(SNAPPY_AMOUNT - 1, SNAPPY_AMOUNT, snappy), 0, 1)
	var wavy = clamp(remap(snappy, SNAPPY_AMOUNT - 1, SNAPPY_AMOUNT, 0, .05), 0, .05)
	snappy = move_toward(snappy, 0, delta)
	spiral = SPIRAL_CURVE.sample(world.get_mesmerized_level()) * SNAPPY_AMOUNT
	world.set_camera_distance(lerp(6, 3, (spiral + 2 * zoomy / (2 * spiral + 1)) / (SNAPPY_AMOUNT)))
	$Spiral.material.set_shader_parameter("show", max(spiral, snappy))
	$Spiral.material.set_shader_parameter("distorsion", clamp(wavy, 0, 0.05))



func _on_world_snap():
	pass


func _on_world_hypnotized():
	snappy = SNAPPY_AMOUNT
