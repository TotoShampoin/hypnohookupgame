extends StaticBody3D

# @export var models: Array[]

# @export var model: MeshInstance3D
@export var cull: float = 2

@onready var models = $Models.get_children()

var tiles: Array[Node3D] = []

var count = 0
var total_scroll = 0
var local_scroll = 0

func _ready():
	$Models.hide()
	count = -cull + 1
	for i in range(-cull + 1, cull + 2):
		add_tile(count)
		count += 1


func _process(_delta):
	pass
	

func forward(delta):
	if local_scroll > 2:
		tiles[0].queue_free()
		tiles.remove_at(0)
		add_tile(count)
		count += 1
		local_scroll -= 2
		
	total_scroll += delta
	local_scroll += delta
	var i = -cull + 1
	for tile in tiles:
		tile.position.x = i * 2 - local_scroll
		i += 1


func add_tile(_counter: int):
	var model = models.pick_random()
	var tile = model.duplicate(8)
	add_child(tile)
	tiles.append(tile)
	tile.show()
	return tile
