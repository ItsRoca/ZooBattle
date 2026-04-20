extends CharacterBody2D

@export var stats: UnitStats: set = set_stats

# Celda que ocupa la unidad en el tablero
var current_cell: Vector2i

# Indica si la unidad es enemiga o aliada
var is_enemy: bool = false

# Vida actual de la unidad
var current_health: float

# Señal que se emite cuando la unidad muere
signal unit_died(unit)

@onready var skin: AnimatedSprite2D = $Skin
@onready var health_bar: ProgressBar = $HealthBar
@onready var mana_bar: ProgressBar = $ManaBar
@onready var attack_timer: Timer = $AttackTimer

func set_stats(value: UnitStats) -> void:
	stats = value
	
	if value == null:
		return
		
	if not is_node_ready():
		await ready
		
	# Aplicar stats a la barra de vida
	health_bar.max_value = stats.max_health
	health_bar.value = stats.max_health
	current_health = stats.max_health
	
	# Configurar el timer de ataque segun la velocidad de ataque
	attack_timer.stop()
	attack_timer.wait_time = 1.0 / stats.attack_speed
	attack_timer.start()
	
# Aplica daño a la unidad teniendo en cuenta la defensa
func take_damage(damage: float) -> void:
	var final_damage = max(0, damage - stats.defense)
	print("Daño base: ", damage, " | Defensa: ", stats.defense, " | Daño final: ", final_damage)
	current_health -= final_damage
	health_bar.value = current_health
	print(stats.name, " recibe ", final_damage, " de daño. Vida restante: ", current_health)
	
	if current_health <= 0:
		die()

# Muerte
func die() -> void:
	unit_died.emit(self)
	print(stats.name, " ha muerto")
	queue_free()
	
func _ready():
	# Añadir la unidad al grupo correspondiente
	if is_enemy:
		add_to_group("enemies")
	else:
		add_to_group("allies")
		
	print("Grupo: ", "enemies" if is_enemy else "allies")
		
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func _on_attack_timer_timeout():
	target = _find_nearest_target()
	if target and is_instance_valid(target):
		var distance = global_position.distance_to(target.global_position)
		if distance <= stats.attack_range * 32:
			target.take_damage(stats.physical_damage)
	
# Objetivo actual de la unidad
var target: CharacterBody2D = null

# Busca el enemigo más cercano
func _find_nearest_target() -> CharacterBody2D:
	# Si es enemigo busca en aliados y viceversa
	var group = "enemies" if not is_enemy else "allies"
	var units = get_tree().get_nodes_in_group(group)
	
	var nearest = null
	var min_distance = INF
	
	for unit in units:
		var distance = global_position.distance_to(unit.global_position)
		if distance < min_distance:
			min_distance = distance
			nearest = unit
	
	return nearest
	
func _physics_process(delta: float) -> void:
	if target and is_instance_valid(target):
		var distance = global_position.distance_to(target.global_position)
		if distance > stats.attack_range * 32:
			# Moverse hacia el objetivo
			var direction = (target.global_position - global_position).normalized()
			velocity = direction * 50.0  # velocidad en píxeles por segundo
		else:
			# Dentro de rango, detenerse
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
