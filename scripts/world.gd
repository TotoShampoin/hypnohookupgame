extends Node3D

signal snap()
signal hypnotized()


@export var CAMERA_SPEED: float = 6

@export var timer_min: float = 0.5
@export var timer_max: float = 1.

@export var folk_scene: PackedScene
@export var folk_behaviours: Array[FolkBehavior]

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
	var other_folks = get_tree().get_nodes_in_group("folks")
	var folk = folk_scene.instantiate()
	$SpawnPath/SpawnLocation.progress_ratio = randf()
	folk.start_at($SpawnPath/SpawnLocation.position)
	var available = folk_behaviours.filter(func(b): return b.can_spawn(folk, $Player, other_folks, $Ground.total_scroll)).pick_random()
	folk.set_behavior(available)
	folk.connect("snap", on_folk_snap)
	folk.connect("update", on_folk_update)
	add_child(folk)


func _on_oob_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	body.queue_free()

func on_folk_snap():
	emit_signal("hypnotized")
	$Player.on_hypnotized(1)

func on_folk_update(folk: Folk, delta: float):
	var other_folks = get_tree().get_nodes_in_group("folks")
	folk.behaviour.react(folk, $Player, other_folks, $Ground.total_scroll, delta)
