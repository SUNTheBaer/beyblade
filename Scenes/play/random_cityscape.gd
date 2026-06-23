class_name RandomizedCityscape
extends TileMapLayer

@export var width: int = 100
@export var height: int = 100
@export var building_scene: PackedScene

var direction_mapping_: Dictionary[int, Vector2i]
var edge_mapping_: Dictionary[int, Vector2i]
var road_map_: PackedByteArray
var building_map_: PackedByteArray


func _ready() -> void:
	_setup.call_deferred()


func _setup() -> void:
	_parse_tileset()
	_generate_roads()
	_place_tiles()
	_place_buildings()


func _parse_tileset() -> void:
	var ts := tile_set.get_source(0) as TileSetAtlasSource
	for i in ts.get_tiles_count():
		var x := ts.get_tile_id(i)
		var data := ts.get_tile_data(x, 0)
		var connecting := data.get_custom_data("connecting") as int
		if 0 <= connecting:
			direction_mapping_[connecting] = x
		var border := data.get_custom_data("border") as int
		if 0 < border:
			edge_mapping_[border] = x


func _generate_roads() -> void:
	for y in height:
		for x in width:
			if x % 5 == 0 or y % 5 == 0:
				road_map_.push_back(1)
			elif x % 3 == 0 or y % 3 == 0:
				road_map_.push_back(1 if 0 == randi_range(0, 4) else 0)
			else:
				road_map_.push_back(1 if 0 == randi_range(0, 16) else 0)


func _place_tiles() -> void:
	for y in height:
		set_cell(Vector2i(-width / 2 - 1, y - height / 2), 0, edge_mapping_[1])
		set_cell(Vector2i(width / 2, y - height / 2), 0, edge_mapping_[3])
	for x in width:
		set_cell(Vector2i(x - width / 2, -height / 2 - 1), 0, edge_mapping_[4])
		set_cell(Vector2i(x - width / 2, height / 2), 0, edge_mapping_[2])
	
	for y in height:
		for x in width:
			var pos := Vector2i(x - width / 2, y - height / 2)
			if _get_road_value(Vector2i(x, y)) == 1:
				set_cell(pos, 0, direction_mapping_[_get_road_type(Vector2i(x, y))])
			else:
				set_cell(pos, 0, direction_mapping_[0])


func _place_buildings() -> void:
	building_map_.resize(road_map_.size())
	building_map_.fill(0)
	
	for y in height - 1:
		for x in width - 1:
			if _get_any_value(Vector2i(x, y)) \
				or _get_any_value(Vector2i(x + 1, y)) \
				or _get_any_value(Vector2i(x, y + 1)) \
				or _get_any_value(Vector2i(x + 1, y + 1)):
				continue
			if randi_range(0, 1) == 0:
				var building := building_scene.instantiate() as Skyscraper
				building.height = floori(sqrt(randf_range(1.0, 100.0)))
				owner.add_child(building)
				building.global_position = Vector2i(x + 1 - width / 2, y + 1 - height / 2) * tile_set.tile_size
				building_map_[(x+0) + (y+0) * width] = 1
				building_map_[(x+1) + (y+0) * width] = 1
				building_map_[(x+0) + (y+1) * width] = 1
				building_map_[(x+1) + (y+1) * width] = 1


func _get_road_type(x: Vector2i) -> int:
	return (_get_road_value(x + Vector2i(1, 0)) << 0) \
		| (_get_road_value(x + Vector2i(0, -1)) << 1) \
		| (_get_road_value(x + Vector2i(-1, 0)) << 2) \
		| (_get_road_value(x + Vector2i(0, 1)) << 3)


func _get_road_value(x: Vector2i) -> int:
	if 0 > x.x or 0 > x.y or width <= x.x or height <= x.y:
		return 0
	return road_map_[x.x + x.y * width]


func _get_any_value(x: Vector2i) -> bool:
	if 0 > x.x or 0 > x.y or width <= x.x or height <= x.y:
		return false
	return road_map_[x.x + x.y * width] > 0 or building_map_[x.x + x.y * width] > 0
