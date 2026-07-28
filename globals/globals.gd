extends Node


@onready var button_click: AudioStreamPlayer = $ButtonClick
@onready var music: AudioStreamPlayer = $AudioStreamPlayer


var settings: Dictionary = {
	Enums.Settings.AUDIO: {
		Enums.Audio_Buses.MASTER: 1,
		Enums.Audio_Buses.ENEMY: 1,
		Enums.Audio_Buses.AUDIO_BOX: 1,
	},
	Enums.Settings.FULLSCREEN: true,
}
var current_settings: Dictionary = settings.duplicate_deep()
var default_settings: Dictionary = settings.duplicate_deep()


var player_data: Dictionary = {
	Enums.Player_Data.INVENTORY: {
		Enums.Items.MINE: 0,
		Enums.Items.SHOTGUN: 0,
	},
	Enums.Player_Data.FLOOR: Enums.Floor.INTRO,
	Enums.Player_Data.OBTAINED_ITEMS: []
}
var default_player_data = player_data.duplicate_deep()


var colours: Dictionary = {
	Enums.Colours.DEFAULT_DOT: Color.WHITE,
	Enums.Colours.WALL: Color.BLUE,
	Enums.Colours.ENEMY: Color.RED,
	Enums.Colours.AUDIO_BOX: Color.GREEN,
	Enums.Colours.PLAYER: Color.WHITE,
	Enums.Colours.LIDAR_BEAM: Color.BLUE,
	Enums.Colours.STAIRS: Color.GOLD,
	Enums.Colours.MINE: Color.PURPLE,
	Enums.Colours.ITEM: Color.LIGHT_PINK,
}
var current_colours: Dictionary = colours.duplicate_deep()
var default_colours: Dictionary = colours.duplicate_deep()


const ITEM_NAMES := {
	Enums.Items.MINE: "Distraction Mine",
	Enums.Items.SHOTGUN: "Shotgun",
}


const FLOOR_SCENES := {
	Enums.Floor.INTRO: "res://floors/Intro.tscn",
	Enums.Floor.FLOOR1: "res://floors/floor_1.tscn",
	Enums.Floor.FLOOR2: "res://floors/floor_2.tscn"
}
