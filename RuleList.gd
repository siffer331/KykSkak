class_name RuleList
extends OptionButton

var selected_id: String setget , _get_selected_id


func _ready():
	#_on_Vals_names_changed()
	Vals.connect("names_changed", self, "_on_Vals_names_changed")


func _on_Vals_names_changed():
	clear()
	add_item("NONE", -1)
	for rule in Vals.names:
		add_item(rule[0], int(rule[1]))


func _get_selected_id() -> String:
	return str(get_selected_id())
