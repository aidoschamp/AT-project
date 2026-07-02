extends Area2D


var angle: Vector2
var velocity: Vector2
var speed := 400.0
var active := true
var colour: Color
var dot_type: Enums.Colours


@onready var despawn_timer: Timer = $DespawnTimer
@onready var off_screen_despawn_timer: Timer = $OffScreenDespawnTimer


func _draw() -> void:
	draw_circle(Vector2.ZERO, 10, colour)


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
		# don't want to hit the player
		if not body is Player:
			active = false
			velocity *= 0
			queue_redraw()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	off_screen_despawn_timer.start()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	off_screen_despawn_timer.stop()


func _on_off_screen_despawn_timer_timeout() -> void:
	queue_free()
