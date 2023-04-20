@tool
extends Node2D

# editor
@export var regenerate:= false :
    set(value):
        if value:
            generate()
            regenerate = false
@export var clear:= false :
    set(value):
        if value:
            for child in get_children():
                child.free()
            clear = false

@export var map_size: int = 32
@export var water_tile_source_id: int = 0
@export var land_tile_source_id: int = 1
@export var water_terrain_set_id : int = 0
@export var land_terrain_set_id : int = 0
@export var water_terrain_id : int = 0
@export var land_terrain_id : int = 1
@export var random_walk_step: int = 1000
@export var tileset :TileSet
@export var ground_patch_size :Vector2 = Vector2(3,3)
var random_walk_start_position: Vector2 = Vector2(map_size / 2, map_size / 2)

@export var object_packed_scenes: Array[PackedScene]

@export var empty_ground_object_packed_scene: PackedScene

var tile_map: TileMap
var object_group: Node2D
var ground_object_group: Node2D
var rng = RandomNumberGenerator.new()

func _ready():
    y_sort_enabled = true

func generate():

    # clear 
    for child in get_children():
        child.free()

    rng.randomize()
    
    # Create WaterTileMap and GroundTileMap
    tile_map = create_tile_map("TileMap")
    
    # Initialize the map with water tiles
    initialize_map()
    
    # Generate land using random walk
    random_walk()

    # Generate objects (e.g., trees) on land tiles
    generate_objects()  # Add this line after the random_walk() function

func create_tile_map(name: String) -> TileMap:
    var tile_map = TileMap.new()
    tile_map.name = name
    tile_map.tile_set = tileset
    tile_map.z_index = -2
    tile_map.global_position = Vector2(-map_size*tileset.tile_size.x/2, -map_size*tileset.tile_size.y/2)
                                # Water layer is default layer
    tile_map.add_layer(-1)      # add Ground layer
    add_child(tile_map,true)
    tile_map.owner = get_tree().edited_scene_root
    return tile_map

func initialize_map():
    var expand_water_border_size = 5
    for x in range(-expand_water_border_size,map_size+expand_water_border_size):
        for y in range(-expand_water_border_size,map_size+expand_water_border_size):
            tile_map.set_cell(0,Vector2(x, y), water_tile_source_id,Vector2i(0, 0),0)

func random_walk():
    var ground_path = []
    # Create a ground patch around the start position
    for x in range(-ground_patch_size.x, ground_patch_size.x + 1):
        for y in range(-ground_patch_size.y, ground_patch_size.y + 1):
            var patch_position = random_walk_start_position + Vector2(x, y)
            patch_position.x = clamp(patch_position.x, 0, map_size - 1)
            patch_position.y = clamp(patch_position.y, 0, map_size - 1)
            # tile_map.set_cell(1, patch_position, land_tile_source_id, Vector2i(1, 1))
            if not ground_path.has(patch_position):
                ground_path.append(patch_position)

    var position: Vector2 = random_walk_start_position
    for _step in range(random_walk_step):
        
        var offset = 2
        for x in range(-offset,offset+1,1):
            for y in range(-offset,offset+1,1):
                var draw_position = Vector2.ZERO
                
                draw_position.x = clamp(position.x +x, 0, map_size - 1)
                draw_position.y = clamp(position.y +y, 0, map_size - 1)
                if not ground_path.has(draw_position):
                    ground_path.append(draw_position)
                # tile_map.set_cell(1,draw_position, land_tile_source_id,Vector2i(1, 1))
                
        position += Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
        position.x = clamp(position.x, 0, map_size - 1)
        position.y = clamp(position.y, 0, map_size - 1)
    tile_map.set_cells_terrain_connect(1,ground_path,0,1)

func generate_objects():

   # Create a new Node2D instance and make it the parent of all objects
    object_group = Node2D.new()
    object_group.name = "ObjectGroup"
    add_child(object_group,true)
    object_group.owner = get_tree().edited_scene_root
    object_group.y_sort_enabled = true

# Create a new Node2D instance and make it the parent of all empty ground tiles
    ground_object_group = Node2D.new()
    ground_object_group.name = "EmptyGroundGroup"
    add_child(ground_object_group,true)
    ground_object_group.owner = get_tree().edited_scene_root
    ground_object_group.z_index = -1

    for x in range(map_size):
        for y in range(map_size):
            var cell = tile_map.get_cell_source_id(1,Vector2(x, y))
            var map_position = tile_map.map_to_local(Vector2(x, y))
            var world_position = tile_map.to_global(map_position)

            # Skip object generation within the ground_patch_size area around the random_walk_start_position
            if x >= random_walk_start_position.x - ground_patch_size.x and x <= random_walk_start_position.x + ground_patch_size.x and \
               y >= random_walk_start_position.y - ground_patch_size.y and y <= random_walk_start_position.y + ground_patch_size.y:
                continue

            var is_on_ground_no_border = true
            var find_ground_range = 1
            for fx in range(-find_ground_range,find_ground_range+1,1):
                for fy in range(-find_ground_range,find_ground_range+1,1):
                    var find_position = Vector2.ZERO
                    find_position.x = x +fx
                    find_position.y = y +fy
                    if tile_map.get_cell_source_id(1,find_position) != land_tile_source_id:
                        is_on_ground_no_border = false
                        break

            if is_on_ground_no_border and not is_object_already_spawned(world_position):
                for object_packed_scene in object_packed_scenes:
                    if rng.randf() < 0.03:
                        if object_packed_scene != null:
                            var instance = object_packed_scene.instantiate()
                            object_group.add_child(instance,true)
                            instance.global_position = world_position
                            instance.owner = get_tree().edited_scene_root
                            break
            
            if empty_ground_object_packed_scene != null:
                if is_on_ground_no_border and not is_object_already_spawned(world_position):
                    var empty_ground_instance = empty_ground_object_packed_scene.instantiate()
                    ground_object_group.add_child(empty_ground_instance,true)
                    empty_ground_instance.global_position = world_position
                    empty_ground_instance.owner = get_tree().edited_scene_root


func is_object_already_spawned(position: Vector2) -> bool:
    var distance_how_far_to_check = tileset.tile_size.x
    for child in object_group.get_children():
        if child.global_position.distance_to(position) < distance_how_far_to_check:
            return true
    return false