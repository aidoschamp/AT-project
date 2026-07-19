extends Area2D


@onready var walls: TileMapLayer = $"../../TileMaps/TileMapLayer"


func _on_body_entered(_body: Node2D) -> void:
	for cell in range(7):
		walls.erase_cell(Vector2i(-63, -95 + cell))

	for area in get_overlapping_areas():
		if area is Dot:
			area.queue_free()
