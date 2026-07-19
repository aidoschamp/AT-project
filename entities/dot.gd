extends Area2D
class_name Dot


var angle: Vector2
var velocity: Vector2
var speed := 400.0
var active := true
var colour: Color
var dot_type: Enums.Colours
var is_shotgun_bullet := false


@onready var despawn_timer: Timer = $DespawnTimer


func _draw() -> void:
	var radius: int = 5 if is_shotgun_bullet else 10
	draw_circle(Vector2.ZERO, radius, colour)


func _ready() -> void:
	colour = Globals.colours.duplicate_deep()[Enums.Colours.DEFAULT_DOT]
	velocity = angle.normalized() * speed


func _process(delta: float) -> void:
	if not get_tree().paused:
		position += velocity * delta
	if colour != Globals.colours[dot_type]:
		colour = Globals.colours.duplicate_deep()[dot_type]
		queue_redraw()


func _on_timer_timeout() -> void:
	queue_free()


# have to use this for the audiobox since they're an area not a body
func _on_area_entered(area: Area2D) -> void:
	if active:
		if area is AudioBox:
			colour = Globals.colours[Enums.Colours.AUDIO_BOX]
			despawn_timer.start(2)
			dot_type = Enums.Colours.AUDIO_BOX
		elif area is Stairs:
			colour = Globals.colours[Enums.Colours.STAIRS]
			despawn_timer.stop()
			dot_type = Enums.Colours.STAIRS
		elif area is Item:
			colour = Globals.colours[Enums.Colours.ITEM]
			despawn_timer.start(2)
			dot_type = Enums.Colours.ITEM
		active = false
		velocity *= 0
		queue_redraw()


func _on_body_entered(body: Node2D) -> void:
	if active:
		if body is TileMapLayer:
			colour = Globals.colours[Enums.Colours.WALL]
			despawn_timer.stop()
			dot_type = Enums.Colours.WALL
		# make dot disappear after 2s since the enemy can move
		elif body is Enemy:
			colour = Globals.colours[Enums.Colours.ENEMY]
			despawn_timer.start(2)
			dot_type = Enums.Colours.ENEMY
			if is_shotgun_bullet:
				if not body.shot:
					body.change_anger(1)
					body.shot = true
				call_deferred("set_enemy_as_parent", body)
		# don't want to hit the player
		if not body is Player:
			active = false
			velocity *= 0
			queue_redraw()


func set_enemy_as_parent(enemy) -> void:
	reparent(enemy)
