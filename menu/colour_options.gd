extends Control


func _on_back_pressed() -> void:
	self.visible = false
	self.get_parent().get_child(0).visible = true
