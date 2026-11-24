class_name Player
extends CharacterBody3D

signal died

@export var stats: PlayerStats
## Falling below this height kills the player.
@export var fall_limit: float = -10.0

@onready var health: HealthComponent = $HealthComponent


func _ready() -> void:
	health.died.connect(_on_health_died)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = stats.jump_velocity

	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input.x, 0.0, input.y)).normalized()
	velocity.x = direction.x * stats.move_speed
	velocity.z = direction.z * stats.move_speed
	move_and_slide()

	if global_position.y < fall_limit:
		health.take_damage(health.max_health)


func _on_health_died() -> void:
	set_physics_process(false)
	died.emit()
	# The parent listens to `died`; the EventBus event is for unrelated systems such as HUD or audio.
	EventBus.player_died.emit()
