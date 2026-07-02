extends Control


func _ready() -> void:
	$Options/FullscreenCheck.button_pressed = Globals.settings[Enums.Settings.FULLSCREEN]


func _on_back_pressed() -> void:
	self.visible = false
	self.get_parent().get_child(0).visible = true


func _on_colours_pressed() -> void:
	$Options.visible = false
	$ColourOptions.visible = true


func _on_fullscreen_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	
	Globals.settings[Enums.Settings.FULLSCREEN] = toggled_on
