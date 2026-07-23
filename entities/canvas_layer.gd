extends CanvasLayer


@onready var gun_timer: Timer = $"../GunTimer"
@onready var reload_bar: ProgressBar = $ReloadBar
@onready var mine_label: Label = $Mines/Label
@onready var shotgun_label: Label = $Shotgun/Label


var obtained_items: Array = Globals.player_data[Enums.Player_Data.OBTAINED_ITEMS]
var inventory: Dictionary = Globals.player_data[Enums.Player_Data.INVENTORY]


func _ready() -> void:
	for item in obtained_items:
		get_child(item).visible = true


func _process(_delta: float) -> void:
	# display how long untill the player can shoot
	reload_bar.value = 1 - gun_timer.time_left / gun_timer.wait_time
