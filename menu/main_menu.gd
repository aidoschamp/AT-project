extends Control


func _ready() -> void:
	get_tree().paused = false
	SaveLoad._load()
	if Globals.player_data[Enums.Player_Data.FLOOR] != Enums.Floor.INTRO:
		$Buttons/DeleteSave.visible = true
	RenderingServer.set_default_clear_color(Color())


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(Globals.FLOOR_SCENES[Globals.player_data[Enums.Player_Data.FLOOR]])


func _on_options_pressed() -> void:
	$Buttons.visible = false
	$Options.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_delete_save_pressed() -> void:
	Globals.player_data = Globals.default_player_data
	$Buttons/DeleteSave.visible = false
	SaveLoad._save()
