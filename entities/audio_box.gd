extends Area2D
class_name AudioBox


var entered := false


@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var tooltip: Label = $CanvasLayer/Tooltip
@onready var dot_deleter: CollisionShape2D = $DotDeleter


func _draw() -> void:
	draw_circle(Vector2.ZERO, 25, Color.BLACK)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and entered:
		animation_player.play("caption")
		dot_deleter.set_deferred("disabled", false)
		for area in get_overlapping_areas():
			if area is Dot:
				if area.dot_type == Enums.Colours.AUDIO_BOX:
					area.queue_free()
		queue_free()


func _on_body_entered(_body: Node2D) -> void:
	tooltip.visible = true
	entered = true


func _on_body_exited(_body: Node2D) -> void:
	tooltip.visible = false
	entered = false
