extends CharacterBody3D

@export var MAX_HEALTH: float = 10
@onready var health = MAX_HEALTH

signal walk(speed, delta)


func _physics_process(delta):
	var walk_speed = health / MAX_HEALTH
	emit_signal("walk", walk_speed, delta)
	move_and_slide()


func on_hypnotized(amount):
	health = move_toward(health, 0, amount)

func get_mesmerized_level():
	return 1 - health / MAX_HEALTH
