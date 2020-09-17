extends Control

var rules := []


func add(rule: String, description: String, id: String) -> void:
	rules.append(id)
	var label := Label.new()
	label.name = id
	label.text = rule
	label.autowrap = true
	label.hint_tooltip = description
	label.mouse_filter = MOUSE_FILTER_STOP
	$Margin/List.add_child(label)


func reset() -> void:
	for id in rules:
		remove(id)


func remove(id: String) -> void:
	if id in rules:
		rules.remove(rules.find(id))
		$Margin/List.get_node(id).queue_free()
