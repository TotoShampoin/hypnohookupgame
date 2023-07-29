extends Node3D

signal snap()
signal hypnotized()

@export var folk_scene: PackedScene

@export var CAMERA_SPEED: float = 6

@export var timer_min: float = 0.5
@export var timer_max: float = 1.

var timer = 0

@onready var camera_distance = $Marker3D/Camera.position
@onready var camera_anchor = $Marker3D.position


func _ready():
	start_timer()

func _physics_process(delta):
	camera_anchor = $Player.position + Vector3(0, .25, -.15)
	$Marker3D/Camera.position = $Marker3D/Camera.position.lerp(camera_distance, delta * CAMERA_SPEED)
	$Marker3D.position = $Marker3D.position.lerp(camera_anchor, delta * CAMERA_SPEED)

func _process(delta):
	timer -= delta
	if timer <= 0:
		spawn_folk()
		start_timer()
	

func _on_player_walk(speed: float, delta: float):
	$Ground.forward(speed * delta)
	
	for folk in get_tree().get_nodes_in_group("folks"):
		folk.forward(speed * delta)


func set_camera_distance(distance: float):
	camera_distance.z = distance # lerp(6, 3, $Player.get_mesmerized_level())

func get_mesmerized_level():
	return $Player.get_mesmerized_level()

func start_timer():
	timer = randf_range(timer_min, timer_max)

func spawn_folk():
	var folk = folk_scene.instantiate()
	$SpawnPath/SpawnLocation.progress_ratio = randf()
	folk.start_at($SpawnPath/SpawnLocation.position)
	folk.connect("snap", on_folk_snap)
	add_child(folk)


func _on_oob_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	body.queue_free()

func on_folk_snap():
	emit_signal("hypnotized")
	$Player.on_hypnotized(1)
