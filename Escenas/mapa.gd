extends Node2D

@onready var game_area = $GameArea
@onready var bench = $Bench

# Diccionario que guarda las celdas ocupadas {Vector2i: Unit}
var occupied_cells: Dictionary = {}

const Unit = preload("res://Escenas/deer.tscn")
const DeerStats = preload("res://Contenedores/deer.tres")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_handle_click(event.global_position)

func _handle_click(click_pos: Vector2):
	print("click_pos global: ", click_pos)
	print("game_area global position: ", game_area.global_position)
	var local = game_area.to_local(click_pos)
	print("local: ", local)
	var cell = game_area.local_to_map(local)
	print("cell: ", cell)
	if game_area.get_cell_source_id(cell) != -1:
		_place_unit(cell, game_area)
		
func _place_unit(cell: Vector2i, tilemap: TileMapLayer):
	# Comprobar si la celda ya está ocupada
	if occupied_cells.has(cell):
		print("Celda ocupada")
		return
		
	var unit = Unit.instantiate()
	add_child(unit)
	unit.global_position = tilemap.to_global(tilemap.map_to_local(cell))
	
	# Registrar la celda como ocupada
	occupied_cells[cell] = unit
	
func _ready():
	# Enemigo de prueba
	var enemy = Unit.instantiate()
	enemy.is_enemy = true # Hay que asignarlo antes de "add_child", si no se daña a si mismo
	add_child(enemy)
	enemy.stats = DeerStats
	enemy.global_position = Vector2(300, 300)
