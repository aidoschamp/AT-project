extends Area2D


@onready var walls: TileMapLayer = $"../../TileMaps/TileMapLayer"
@onready var wall_break_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _on_body_entered(_body: Node2D) -> void:
	wall_break_sound.play()

	for cell in range(7):
		walls.erase_cell(Vector2i(-63, -96 + cell))

	for area in get_overlapping_areas():
		if area is Dot:
			area.queue_free()
