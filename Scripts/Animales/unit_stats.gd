#Definimos la clase y la extension crear archivos .tres con estos datos desde el editor de Godot
class_name UnitStats
extends Resource

#Indicamos los 4 tipos de rareza que estaran disponibles
enum Rarity {COMMON, RARE, EPIC, LEGENDARY}

#Asignamos colores a cada rareza
const RARITY_COLORS := {
	Rarity.COMMON: Color(0.169, 0.482, 0.149, 1.0),
	Rarity.RARE: Color(0.251, 0.459, 0.871, 1.0),
	Rarity.EPIC: Color(0.475, 0.149, 0.549, 1.0),
	Rarity.LEGENDARY: Color(0.812, 0.533, 0.071, 1.0),
}

# Nombre de la unidad
@export var name: String

@export_category("Data")
# Rareza
@export var rarity: Rarity
# Coste de oro
@export var gold_cost := 1
# Vida máxima
@export var max_health := 100.0
# Defensa
@export var defense := 0.0
# Daño físico por ataque
@export var physical_damage := 10.0
# Velocidad de ataque (ataques por segundo)
@export var attack_speed := 1.0
# Rango de ataque (en celdas)
# No se puede llamar "range" porque es una palabra reservada
@export var attack_range := 1

# Devuelve el nombre de la unidad si intento un print de esta
func _to_string() -> String:
	return name
