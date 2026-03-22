extends CharacterBody2D

@export var stats: UnitStats: set = set_stats

@onready var skin: AnimatedSprite2D = $Skin
@onready var health_bar: ProgressBar = $HealthBar
@onready var mana_bar: ProgressBar = $ManaBar

func set_stats(value: UnitStats) -> void:
	stats = value
	
	if value == null:
		return
		
	if not is_node_ready():
		await ready
		
	# Aplicar stats a la barra de vida
	health_bar.max_value = stats.max_health
	health_bar.value = stats.max_health
