extends Node3D

signal snap()
signal hypnotized()


@export var CAMERA_SPEED: float = 3
@export var ZOOM_SPEED: float = 6
@export var TIMER_MINMIN: float = 0.25
@export var TIMER_MIN: float = 0.75
@export var TIMER_MAX: float = 1.25


@export var folk_scene: PackedScene
@export var folk_behaviours: Array[FolkBehavior]
@export var fb_distribution: Array[int]

var timer_min: float = TIMER_MIN
var timer_max: float = TIMER_MAX
var timer = 0

@onready var camera_distance = $Marker3D/Camera.position
@onready var camera_anchor = $Marker3D.position


func _ready():
	camera_anchor = Vector3(0, 0, 0)
	if folk_behaviours.size() != fb_distribution.size():
		push_error("Distribution rule not matching Behaviours list")
	start_timer()

func _physics_process(delta):
	# camera_anchor = $Player.position + Vector3(0, .25, -.15)
	$Marker3D/Camera.position = $Marker3D/Camera.position.lerp(camera_distance, delta * ZOOM_SPEED)
	$Marker3D.position = $Marker3D.position.lerp(camera_anchor, delta * CAMERA_SPEED)

func _process(delta):
	timer -= delta
	if timer <= 0:
		spawn_folk()
		start_timer()
	
	timer_min = TIMER_MIN - clamp($Ground.total_scroll * TIMER_MIN / 100, TIMER_MINMIN, TIMER_MIN)
	timer_max = TIMER_MAX - clamp($Ground.total_scroll * TIMER_MIN / 100, TIMER_MINMIN, TIMER_MIN)
	# print(timer_min)
	

func _on_player_walk(speed: float, delta: float):
	$Ground.forward(speed * delta)
	
	for folk in get_tree().get_nodes_in_group("folks"):
		folk.forward(speed * delta)


func get_player_position():
	return $Player.position + Vector3(0, .25, -.15)

func set_camera_from_hypno(hypno: float):
	camera_distance.z = lerp(6, 3, hypno)
	camera_anchor = Vector3(0, 0, 0).lerp($Player.position + Vector3(0, .25, -.15), hypno)

func set_camera_distance(distance: float):
	camera_distance.z = distance # lerp(6, 3, $Player.get_mesmerized_level())

func get_mesmerized_level():
	return $Player.get_mesmerized_level()

func start_timer():
	timer = randf_range(timer_min, timer_max)

func pick_random_behaviour(folk: Folk):
	var other_folks = get_tree().get_nodes_in_group("folks")
	var full_list: Array[FolkBehavior] = []
	var available_list: Array[FolkBehavior] = []
	for i in folk_behaviours.size():
		for j in fb_distribution[i]:
			full_list.push_back(folk_behaviours[i])
	for fb in full_list:
		if fb.can_spawn(folk, $Player, other_folks, $Ground.total_scroll):
			available_list.push_back(fb)
	var behaviour = available_list.pick_random()
	return behaviour

func spawn_folk():
	var other_folks = get_tree().get_nodes_in_group("folks")
	var folk = folk_scene.instantiate()
	$SpawnPath/SpawnLocation.progress_ratio = randf()
	folk.start_at($SpawnPath/SpawnLocation.position)
	var available = pick_random_behaviour(folk)
	folk.set_behavior(available)
	folk.connect("snap", on_folk_snap)
	folk.connect("update", on_folk_update)
	add_child(folk)
	folk.behaviour.on_spawn(folk, $Player, other_folks, $Ground.total_scroll)

func _on_oob_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	body.queue_free()

func on_folk_snap(folk: Folk):
	if $Player.on_hypnotized(1):
		emit_signal("hypnotized")
		folk.apply_snap()

func on_folk_update(folk: Folk, delta: float):
	var other_folks = get_tree().get_nodes_in_group("folks")
	folk.behaviour.react(folk, $Player, other_folks, $Ground.total_scroll, delta)
