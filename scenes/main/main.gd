extends Node3D

@onready var player: Player = $Player


func _ready() -> void:
	player.died.connect(_on_player_died)


func _on_player_died() -> void:
	# Deferred so the reload doesn't happen mid physics step.
	get_tree().reload_current_scene.call_deferred()
