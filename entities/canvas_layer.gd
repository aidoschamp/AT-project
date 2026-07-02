extends CanvasLayer


@onready var gun_timer: Timer = $"../GunTimer"
@onready var reload_bar: ProgressBar = $ReloadBar


func _process(_delta: float) -> void:
	# display how long untill the player can shoot
	reload_bar.value = 1 - gun_timer.time_left / gun_timer.wait_time
