class_name RuleEdit
extends PanelContainer

signal updated_data(data)
signal removed(id)

var in_game := false
var data : Dictionary

func initialize(data: Dictionary) -> void:
	name = str(data.id)
	self.data = data
	_update_ui()


func disable(val: bool) -> void:
	data.disabled = val


func _update_ui() -> void:
	$Margin/Split/Name/Margin/Label.text = data.name


func _on_Settings_pressed() -> void:
	$Margin/Split/Name/Settings/Popup/Margin/Split/Title.text = data.name
	$Margin/Split/Name/Settings/Popup/Margin/Split/Description.text = data.description
	$Margin/Split/Name/Settings/Popup.popup_centered()


func _on_RemoveButton_pressed() -> void:
	emit_signal("removed", data.id)
	queue_free()


func _on_Popup_popup_hide() -> void:
	data.name = $Margin/Split/Name/Settings/Popup/Margin/Split/Title.text
	data.description = $Margin/Split/Name/Settings/Popup/Margin/Split/Description.text
	$Margin/Split/Name/Margin/Label.text = data.name
	rect_size.y = 0
	_update_ui()
	emit_signal("updated_data", data)
