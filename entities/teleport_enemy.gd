extends Area2D


@export var enemy: Enemy
@export var location: Node2D

func _on_body_entered(_body: Node2D) -> void:
	enemy.position = location.position
	if not enemy.active:
		enemy.initialise()
	
	queue_free()
