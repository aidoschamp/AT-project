extends Area2D
class_name DistractionMine


const DOT_COUNT = 10.0
const DOT_SCENE: PackedScene = preload("res://entities/dot.tscn")
@onready var lidars: Node = $"../../Lidars"
var hearable = true
var colour: Color = Globals.colours.duplicate_deep()[Enums.Colours.MINE]
@onready var enemy: Enemy = $"../../Enemy"


func _process(_delta: float) -> void:
	if colour != Globals.colours[Enums.Colours.MINE]:
		colour = Globals.colours.duplicate_deep()[Enums.Colours.MINE]
		queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 15, Globals.colours[Enums.Colours.MINE])


func destroy() -> void:
	enemy.remove_target(self)
	enemy.change_anger(0.5)
	queue_free()


func _on_shoot_timer_timeout() -> void:
	for i in range(DOT_COUNT):
		var dot: Area2D = DOT_SCENE.instantiate() # create dot
		var angle: Vector2 = Vector2.RIGHT
		angle = angle.rotated((2 * PI - 2 * PI / DOT_COUNT) * (i / (DOT_COUNT - 1)) - (2 * PI - 2 * PI / DOT_COUNT) / 2) # position angle so that each dot is evenly spread
		dot.position = position
		dot.angle = angle.normalized()
		lidars.add_child(dot)


func _on_body_entered() -> void:
	destroy()


func _on_despawn_timer_timeout() -> void:
	destroy()
