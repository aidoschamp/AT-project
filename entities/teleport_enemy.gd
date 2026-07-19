extends Area2D


@onready var enemy: Enemy = $"../../Enemy"
@onready var location: Node2D = $Location


@export var change_enemy_state: bool = true


func _on_body_entered(_body: Node2D) -> void:
	enemy.position = location.position
	if change_enemy_state:
		if not enemy.active:
			enemy.initialise()
		else:
			enemy.stop()
	
	queue_free()
