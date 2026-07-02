extends ColorPickerButton


@export var colour_item: Enums.Colours
var colour_picker = get_picker()


func _ready() -> void:
	color = Globals.colours[colour_item]
	colour_picker.presets_visible = false


func _on_color_changed(colour: Color) -> void:
	Globals.colours[colour_item] = colour
