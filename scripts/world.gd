extends Node3D

signal snap()
signal hypnotized()

@export var CAMERA_SPEED: float = 6

@onready var camera_distance = $Marker3D/Camera.position
@onready var camera_anchor = $Marker3D.position


func _ready():
	pass

func _physics_process(delta):
	$Marker3D/Camera.position = $Marker3D/Camera.position.lerp(camera_distance, delta * CAMERA_SPEED)
	$Marker3D.position = $Marker3D.position.lerp(camera_anchor, delta * CAMERA_SPEED)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("hypnotized")
		$Player.on_hypnotized(1)

func _on_player_walk(speed: float, delta: float):
	$Ground.forward(speed * delta)

func set_camera_distance(distance: float):
	camera_distance.z = distance # lerp(6, 3, $Player.get_mesmerized_level())

func get_mesmerized_level():
	return $Player.get_mesmerized_level()
