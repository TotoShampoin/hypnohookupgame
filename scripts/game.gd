extends Control

var spiral = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spiral > 0:
		spiral -= delta
	$Spiral.material.set_shader_parameter("show", clamp(spiral, 0, 1))
	$Spiral.material.set_shader_parameter("distorsion", clamp(remap(spiral, .7, 1, 0, .05), 0, 0.05))
	if Input.is_action_just_pressed("ui_accept"):
		spiral = 1
