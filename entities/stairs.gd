extends Area2D
class_name Stairs


var entered := false


@export var location: Enums.Floor


@export var tooltip: Label


func change_scene():
	Globals.player_data[Enums.Player_Data.FLOOR] = location
	SaveLoad._save()
	get_tree().change_scene_to_file(Globals.FLOOR_SCENES[location])


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and entered:
		call_deferred("change_scene")


func _on_body_entered(_body: Node2D) -> void:
	tooltip.visible = true
	entered = true


func _on_body_exited(_body: Node2D) -> void:
	tooltip.visible = false
	entered = false
