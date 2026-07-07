extends Control


func _ready() -> void:
	if get_parent() is CanvasLayer:
		$OptionButtons/Back_Quit.text = "Quit"


func _input(event: InputEvent) -> void:
	if get_parent() is CanvasLayer:
		if event.is_action_pressed("pause") and not get_tree().paused:
			get_tree().paused = true
			visible = true
		elif event.is_action_pressed("pause"):
			unpause()
			back()


func _process(_delta: float) -> void:
	if Globals.current_colours != Globals.colours or Globals.current_settings != Globals.settings:
		$SaveSettings.visible = true
	else:
		$SaveSettings.visible = false


func back() -> void:
	self.visible = false
	if Globals.current_colours != Globals.colours or Globals.current_settings != Globals.settings:
		Globals.settings = Globals.current_settings.duplicate_deep()
		Globals.colours = Globals.current_colours.duplicate_deep()
		
		if Globals.settings[Enums.Settings.FULLSCREEN]:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			$GraphicsOptions/Options/FullscreenCheck.text = "Windowed"
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			$GraphicsOptions/Options/FullscreenCheck.text = "Fullscreen"
		
		for bus in Enums.Audio_Buses.values():
			$AudioOptions/Options.get_child(bus).get_child(1).value = Globals.settings[Enums.Settings.AUDIO][bus]
			var db = linear_to_db(Globals.settings[Enums.Settings.AUDIO][bus])
			AudioServer.set_bus_volume_db(bus, db)
		
		for colour_picker in $GraphicsOptions/ColourOptions/Options/GridContainer.get_children():
			colour_picker.color = Globals.colours[colour_picker.colour_item]
	
	if self.get_parent() is Control:
		self.get_parent().get_child(0).visible = true


func unpause() -> void:
	get_tree().paused = false


func _on_back_pressed() -> void:
	if get_parent() is CanvasLayer:
		get_tree().quit()
	back()


func _on_audio_pressed() -> void:
	$OptionButtons.visible = false
	$AudioOptions.visible = true


func _on_save_settings_pressed() -> void:
	SaveLoad._save_settings()


func _on_graphics_pressed() -> void:
	$OptionButtons.visible = false
	$GraphicsOptions.visible = true
