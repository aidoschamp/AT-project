extends Area2D
class_name Item


var entered := false


@onready var tooltip: Label = $CanvasLayer/Tooltip
@onready var player: Player = $"../../player"
@onready var canvas: CanvasLayer = $"../../player/CanvasLayer"


@export var item: Enums.Items


var obtained_items: Array = Globals.player_data[Enums.Player_Data.OBTAINED_ITEMS]


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and entered:
		var item_gui: Control = canvas.get_child(item)
		player.inventory[item] += 1
		item_gui.get_child(0).text = str(player.inventory[item])
		if not item in obtained_items:
			obtained_items.append(item)
			item_gui.visible = true
		queue_free()


func _on_body_entered(_body: Node2D) -> void:
	tooltip.text = "Pickup " + Globals.ITEM_NAMES[item] + "\n⎵"
	tooltip.visible = true
	entered = true


func _on_body_exited(_body: Node2D) -> void:
	tooltip.visible = false
	entered = false
