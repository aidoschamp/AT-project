extends Area2D
class_name AudioBox


var entered := false


@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var tooltip: Label = $CanvasLayer/Tooltip


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and entered:
		for area in get_overlapping_areas():
			if area is Dot:
				area.queue_free()
		animation_player.play("caption")
		queue_free()


func _on_body_entered(_body: Node2D) -> void:
	tooltip.visible = true
	entered = true


func _on_body_exited(_body: Node2D) -> void:
	tooltip.visible = false
	entered = false
