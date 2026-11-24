extends Node3D


func _ready() -> void:
	EventBus.player_died.connect(_on_player_died)


func _on_player_died() -> void:
	# Deferred so the reload doesn't happen mid physics step.
	get_tree().reload_current_scene.call_deferred()
