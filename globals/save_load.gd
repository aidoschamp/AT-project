extends Node


const save_location = "user://SaveFile.json"


var contents_to_save: Dictionary = {
	"colours": Globals.colours,
	"player_data": Globals.player_data,
	"settings": Globals.settings,
}


func _ready() -> void:
	_load()


func _save() -> void:
	contents_to_save["colours"] = Globals.colours
	contents_to_save["player_data"] = Globals.player_data
	contents_to_save["settings"] = Globals.settings
	var file := FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()


func _save_settings() -> void:
	Globals.current_colours = Globals.colours.duplicate_deep()
	Globals.current_settings = Globals.settings.duplicate_deep()
	contents_to_save["colours"] = Globals.colours
	contents_to_save["settings"] = Globals.settings
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()


func _load() -> void:
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data: Dictionary = data
		Globals.colours = save_data["colours"].duplicate_deep()
		Globals.current_colours = save_data["colours"].duplicate_deep()
		Globals.player_data = save_data["player_data"].duplicate_deep()
		Globals.settings = save_data["settings"].duplicate_deep()
		Globals.current_settings = save_data["settings"].duplicate_deep()
		if Globals.settings[Enums.Settings.FULLSCREEN]:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
