extends HSlider


@export var bus: Enums.Audio_Buses


func _ready() -> void:
	self.value = Globals.settings[Enums.Settings.AUDIO][bus]


@warning_ignore("shadowed_variable_base_class")
func _on_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus, db)
	Globals.settings[Enums.Settings.AUDIO][bus] = value
