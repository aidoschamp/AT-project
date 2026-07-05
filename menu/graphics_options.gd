extends Control


func _ready():
	if Globals.settings[Enums.Settings.FULLSCREEN]:
		$Options/FullscreenCheck.text = "Windowed"
	else:
		$Options/FullscreenCheck.text = "Fullscreen"


func _on_back_pressed() -> void:
	self.visible = false
	self.get_parent().get_child(1).visible = true


func _on_colours_pressed() -> void:
	$Options.visible = false
	$ColourOptions.visible = true


func _on_fullscreen_check_pressed() -> void:
	if Globals.settings[Enums.Settings.FULLSCREEN]:
		$Options/FullscreenCheck.text = "Fullscreen"
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	else:
		$Options/FullscreenCheck.text = "Windowed"
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
	Globals.settings[Enums.Settings.FULLSCREEN] = not Globals.settings[Enums.Settings.FULLSCREEN]
