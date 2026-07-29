extends Control


@onready var thanks_timer: Timer = $ThanksTimer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var black_screen: ColorRect = $BlackScreen
@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2
@onready var thanks: Label = $Thanks


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.player_data = Globals.default_player_data
	SaveLoad._save()
	thanks_timer.start()
	await thanks_timer.timeout
	thanks_timer.start()
	thanks.visible = true
	await thanks_timer.timeout
	black_screen.visible = true
	Globals.music.stop()
	audio_stream_player.play()
	await audio_stream_player.finished
	call_deferred("goto_main_menu")


func goto_main_menu() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")
