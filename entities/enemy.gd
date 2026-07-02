extends CharacterBody2D
class_name Enemy


const MAX_SPEED = 100.0
const ACCELERATION = 1200
@export var player: Player
@export var step_timer: Timer
@export var nav: NavigationAgent2D
@export var steps: AudioStreamPlayer2D
@export var anger_timer: Timer


var active := false


# changes max speed and how often steps gets played
var anger: float = 0
var base_anger: float = 0


var targets: Array[Node2D]
var current_target: Node2D = null


func initialise() -> void:
	step_timer.start()
	current_target = player
	targets.append(player)
	nav.target_position = player.global_position
	active = true


func stop() -> void:
	active = false


func _physics_process(delta: float) -> void:
	if active:
		# find closest hearable target
		for target in targets:
			if not target.hearable:
				continue
			if nav.distance_to_target() > (target.global_position - position).length() or target == current_target or not current_target.hearable:
				nav.target_position = target.global_position
				current_target = target

		# moves towards target
		if not nav.is_target_reached():
			var direction := to_local(nav.get_next_path_position()).normalized()
			velocity = velocity.move_toward(direction * (MAX_SPEED + anger * 200), ACCELERATION * delta)
		else:
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
		step_timer.wait_time = 1.5 - anger
	if anger_timer.is_stopped():
		anger_timer.start()
	else:
		anger_timer.wait_time += 2


func _on_anger_timer_timeout() -> void:
	anger = base_anger
