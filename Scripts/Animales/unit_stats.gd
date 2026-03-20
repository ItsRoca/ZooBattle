#Definimos la clase y la extension crear archivos .tres con estos datos desde el editor de Godot
class_name UnitStats
extends Resource

#Indicamos los 4 tipos de rareza que estaran disponibles
enum Rarity {COMMON, RARE, EPIC, LEGENDARY}

const RARITY_COLORS := {
	Rarity.COMMON: Color(0.169, 0.482, 0.149, 1.0),
	Rarity.RARE: Color(0.251, 0.459, 0.871, 1.0),
	Rarity.EPIC: Color(0.475, 0.149, 0.549, 1.0),
	Rarity.LEGENDARY: Color(0.812, 0.533, 0.071, 1.0),
}

@export var name: String

@export_category("Data")
@export var rarity: Rarity
@export var gold_cost := 1

@export_category("Visuals")
@export var skin_coordinates: Vector2i

func _to_string() -> String:
	return name
