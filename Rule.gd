class_name RuleEdit
extends PanelContainer

signal updated_data(data)
signal removed(id)

export var base_color: Color
export var disable_color: Color
export var in_game_color: Color

var in_game := false setget _set_in_game
var data : Dictionary
var properties = {
	name = "text",
	description = "text",
	disabled = "pressed",
	avaliable = "value",
	requires = "selected_id"
}

var label: Label

func initialize(data: Dictionary) -> void:
	label = $Margin/Split/Name/Margin/Label
	name = str(data.id)
	self.data = data
	_update_ui()


func disable(val: bool) -> void:
	data.disabled = val


func _set_in_game(val: bool):
	in_game = val
	_update_ui()


func _update_ui() -> void:
	label.text = data.name
	$Margin/Split/Name/Settings.hint_tooltip = data.description
	if in_game:
		label.modulate = in_game_color
	else:
		if data.disabled:
			label.modulate = disable_color
		else:
			label.modulate = base_color


func _on_Settings_pressed() -> void:
	for properti in properties:
		$Margin/Split/Name/Settings/Popup/Margin/Scroll/Split.get_node(properti).set(properties[properti], data[properti])
	$Margin/Split/Name/Settings/Popup.popup_centered()


func _on_RemoveButton_pressed() -> void:
	emit_signal("removed", data.id)
	queue_free()


func _on_Popup_popup_hide() -> void:
	for properti in properties:
		data[properti] = $Margin/Split/Name/Settings/Popup/Margin/Scroll/Split.get_node(properti).get(properties[properti])
	$Margin/Split/Name/Margin/Label.text = data.name
	rect_size.y = 0
	_update_ui()
	emit_signal("updated_data", data)
