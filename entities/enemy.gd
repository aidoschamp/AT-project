extends CharacterBody2D
class_name Enemy


const MAX_SPEED = 100.0
const ACCELERATION = 1200
@onready var player: Player = $"../player"
@onready var step_timer: Timer = $StepTimer
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var steps: AudioStreamPlayer2D = $Steps
@onready var anger_timer: Timer = $AngerTimer
@onready var breath: AudioStreamPlayer2D = $Breath
@onready var breath_timer: Timer = $BreathTimer
@onready var shot_move_locations: Node = $"../ShotMoveLocations"



var active := false
var shot := false


# changes max speed and how often steps gets played
var anger: float = 0
var base_anger: float = 0


var targets: Array[Node2D]
var current_target: Node2D = null


func _draw() -> void:
	draw_circle(Vector2.ZERO, 30, Color())


func initialise() -> void:
	step_timer.start()
	breath_timer.start()
	current_target = player
	targets.append(player)
	targets.append_array(shot_move_locations.get_children())
	nav.target_position = player.global_position
	active = true


func stop() -> void:
	breath_timer.stop()
	velocity = Vector2.ZERO
	active = false
	step_timer.stop()


func check_target() -> void:
	# find closest hearable target
	for target in targets:
		# skips over if target isn't hearable (this part always is false if they're shot though), and also skips over if target is a marker and they're not shot
		if (not target.hearable and not shot) or (not target is Marker2D and shot):
			continue

		var target_closer = nav.distance_to_target() > (target.global_position - position).length()
		var change_to_marker = not current_target is Marker2D and shot
		if target_closer or target == current_target or not current_target.hearable or change_to_marker:
			nav.target_position = target.global_position
			current_target = target


func _physics_process(delta: float) -> void:
	if active:
		check_target()

		# moves towards target
		if not nav.is_target_reached():
			var direction := to_local(nav.get_next_path_position()).normalized()
			velocity = velocity.move_toward(direction * (MAX_SPEED + anger * 200), ACCELERATION * delta)
		else:
			if shot:
				shot = false
			velocity = Vector2.ZERO

	move_and_slide()


func add_target(target: Node2D) -> void:
	targets.append(target)


func remove_target(target: Node2D) -> void:
	if target == current_target:
		current_target = player
	targets.erase(target)


func _on_step_timer_timeout() -> void:
	steps.play()


func change_anger(new_anger) -> void:
	if anger < base_anger + new_anger:
		anger = base_anger + new_anger
		step_timer.wait_time = 1.5 - anger * 1.3
	if anger_timer.is_stopped():
		anger_timer.start()
	else:
		anger_timer.wait_time += 2


func _on_anger_timer_timeout() -> void:
	anger = base_anger
	step_timer.wait_time = 1.5


func _on_breath_timer_timeout() -> void:
	breath.play()
