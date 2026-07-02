extends Area2D


@onready var enemy: Enemy = $"../../Enemy"
@onready var location: Node2D = $Location


func _on_body_entered(_body: Node2D) -> void:
	enemy.position = location.position
	if not enemy.active:
		enemy.initialise()
	else:
		enemy.stop()
	
	queue_free()
