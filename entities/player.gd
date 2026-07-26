extends CharacterBody2D
class_name Player


const MAX_SPEED := 300.0
const ACCELERATION := 1200


@onready var enemy: Enemy = $"../Enemy"
@onready var gun_timer: Timer = $GunTimer
@onready var lidars: Node = $"../Lidars"
@onready var mines: Node = $"../Mines"
@onready var mine_label: Label = $CanvasLayer/Mines/Label
@onready var shotgun_label: Label = $CanvasLayer/Shotgun/Label


const DOT_COUNT := 5
const DOT_SCENE: PackedScene = preload("res://entities/dot.tscn")
const MINE_SCENE: PackedScene = preload("res://item/distraction_mine.tscn")


var current_spread := PI / 3
var spread_change_amount := PI / 9
var max_spread := 3 * PI / 4
var hearable := false
var inventory = Globals.player_data[Enums.Player_Data.INVENTORY]
var player_colour: Color
var lidar_beam_colour: Color


@onready var jarvis_mode_timer: Timer = $JarvisModeTimer
var jarvis_mode: bool = false


var dead: bool = false
@onready var death_sound: AudioStreamPlayer = $DeathSound


func _draw() -> void:
	player_colour = Globals.colours[Enums.Colours.PLAYER]
	lidar_beam_colour = Globals.colours[Enums.Colours.LIDAR_BEAM]
	draw_circle(Vector2.ZERO, 15, player_colour)
	var points: PackedVector2Array
	points.append(Vector2.ZERO)
	var angle: float
	for i in range(32):
		angle = current_spread * (i / 31.0) - current_spread / 2.0
		points.append(Vector2(400 * cos(angle), 400 * sin(angle)))
	draw_polygon(points, PackedColorArray([Color(lidar_beam_colour, 0.5)]))


func _physics_process(delta: float) -> void:
	if player_colour != Globals.colours[Enums.Colours.PLAYER] or lidar_beam_colour != Globals.colours[Enums.Colours.LIDAR_BEAM]:
		queue_redraw()
	if get_tree().paused or dead:
		return
	look_at(get_global_mouse_position())
	# get input direction
	var direction := Input.get_vector("left", "right", "up", "down")
	
	# apply acceleration to player with vector
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	elif velocity != Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
	
	# if moving enemy can hear player
	hearable = velocity != Vector2.ZERO
	
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is Enemy:
			die()


func go_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")


func die() -> void:
	dead = true
	enemy.step_timer.stop()
	enemy.breath_timer.stop()
	death_sound.play()
	await death_sound.finished
	call_deferred("go_to_main_menu")


func _input(event: InputEvent) -> void:
	if not get_tree().paused and not dead:
		if event.is_action_pressed("jarvis mode"):
			jarvis_mode_timer.start()
		if event.is_action_released("jarvis mode"):
			jarvis_mode_timer.stop()


		if event.is_action_pressed("place mine") and inventory[Enums.Items.MINE] > 0:
			place_mine()

		# shoot only if gun is reloaded
		if event.is_action_pressed("lidar shoot") and gun_timer.time_left == 0:
			gun_timer.start()
			create_dots(current_spread, DOT_COUNT, false)
		
		
		if event.is_action_pressed("shotgun shoot") and inventory[Enums.Items.SHOTGUN] > 0:
			create_dots(PI/3, DOT_COUNT*2, true)
			inventory[Enums.Items.SHOTGUN] -= 1
			shotgun_label.text = str(inventory[Enums.Items.SHOTGUN])
		
		
		var spread_change_direction := Input.get_axis("decrease spread", "increase spread")
		
		# change spread of dots if not trying to change out of spread bounds
		if current_spread + spread_change_amount < max_spread and spread_change_direction == 1 or current_spread - spread_change_amount > PI / 3 and spread_change_direction == -1:
			current_spread += spread_change_amount * spread_change_direction
			queue_redraw()
		elif spread_change_direction == 1:
			current_spread = max_spread
			queue_redraw()
		elif spread_change_direction == -1:
			current_spread = PI / 3
			queue_redraw()


func create_dots(spread: float, amount: int, is_shotgun_bullet: bool) -> void:
	for i in range(amount):
		var dot: Dot = DOT_SCENE.instantiate() # create dot
		var angle: Vector2 = get_global_mouse_position() - global_position # set base angle and fix for player rotation
		angle = angle.rotated(spread * (i / (float(amount) - 1)) - spread / 2) # position angle so that each dot is evenly spread
		dot.position = position
		dot.angle = angle.normalized()
		dot.is_shotgun_bullet = is_shotgun_bullet
		lidars.add_child(dot)


func place_mine() -> void:
	inventory[Enums.Items.MINE] -= 1
	mine_label.text = str(inventory[Enums.Items.MINE])
	var mine: DistractionMine = MINE_SCENE.instantiate() # create mine
	mine.position = position
	mines.add_child(mine)
	enemy.add_target(mine)


func _on_jarvis_mode_timer_timeout() -> void:
	jarvis_mode = not jarvis_mode
	if jarvis_mode:
		RenderingServer.set_default_clear_color(Color(0.302, 0.302, 0.302))
	else:
		RenderingServer.set_default_clear_color(Color())
