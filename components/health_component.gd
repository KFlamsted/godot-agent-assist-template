## Reusable health. Add as a child node and connect to its signals.
class_name HealthComponent
extends Node

signal health_changed(current: int, maximum: int)
signal damaged(amount: int)
signal healed(amount: int)
signal died

@export_range(1, 1000) var max_health: int = 100
@export var invincible: bool = false

var current_health: int:
	set(value):
		var old := current_health
		current_health = clampi(value, 0, max_health)
		if current_health != old:
			health_changed.emit(current_health, max_health)


func _ready() -> void:
	current_health = max_health


func is_dead() -> bool:
	return current_health <= 0


## Returns the damage actually dealt after clamping.
func take_damage(amount: int) -> int:
	if is_dead() or invincible or amount <= 0:
		return 0
	var before := current_health
	current_health -= amount
	var dealt := before - current_health
	damaged.emit(dealt)
	if is_dead():
		died.emit()
	return dealt


func heal(amount: int) -> void:
	if is_dead() or amount <= 0:
		return
	var before := current_health
	current_health += amount
	var restored := current_health - before
	if restored > 0:
		healed.emit(restored)
