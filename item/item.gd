extends Area2D
class_name Item


var entered := false


@export var tooltip: Label
@export var player: Player


@export var item: Enums.Items


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and entered:
		player.inventory[item] += 1
		queue_free()


func _on_body_entered(_body: Node2D) -> void:
	tooltip.text = "Pickup " + Globals.ITEM_NAMES[item] + "\n⎵"
	tooltip.visible = true
	entered = true


func _on_body_exited(_body: Node2D) -> void:
	tooltip.visible = false
	entered = false
