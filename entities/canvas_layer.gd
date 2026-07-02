extends CanvasLayer


@export var gun_timer: Timer
@export var progress_bar: ProgressBar


func _process(_delta: float) -> void:
	# display how long untill the player can shoot
	progress_bar.value = 1 - gun_timer.time_left / gun_timer.wait_time
