extends Control


func _ready() -> void:
	SaveLoad._load()
	RenderingServer.set_default_clear_color(Color())


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(Globals.FLOOR_SCENES[Globals.player_data[Enums.Player_Data.FLOOR]])


func _on_options_pressed() -> void:
	$MainButtons.visible = false
	$Options.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()
