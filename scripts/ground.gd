extends StaticBody3D

@export var model: MeshInstance3D
@export var cull: float = 2

var tiles: Array[MeshInstance3D] = []

var count = 0
var total_scroll = 0
var local_scroll = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	model.hide()
	count = -cull + 1
	for i in range(-cull + 1, cull + 2):
		var tile = addTile(count)
		count += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	# for i in range(-cull, cull + 1):
	# 	tiles[i].position.x = i * model.scale.x * 2 - fmod(scroll, model.scale.x * 2)
	

func forward(delta):
	# for tile in tiles:
	# 	if tile.position.x < -cull * model.scale.x * 2:
	# 		tile.queue_free()
	# 		tiles.erase(tile)
	# 		local_scroll -= model.scale.x * 2
	# 		var new_tile = addTile()
	# 		new_tile.position.x = (cull - 1) * model.scale.x * 2
	if local_scroll > model.scale.x * 2:
		tiles[0].queue_free()
		tiles.remove_at(0)
		addTile(count)
		count += 1
		local_scroll -= model.scale.x * 2
		
	total_scroll += delta
	local_scroll += delta
	var i = -cull + 1
	for tile in tiles:
		tile.position.x = i * model.scale.x * 2 - local_scroll #  fmod(scroll, model.scale.x * 2)
		i += 1


func addTile(counter: int):
	var tile: MeshInstance3D = model.duplicate(8)
	add_child(tile)
	tiles.append(tile)
	tile.show()
	tile.get_node("Label3D").text = str(counter)
	return tile
