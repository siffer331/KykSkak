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
	$Margin/Scroll/List.add_child(label)


func reset() -> void:
	rules = []
	for child in $Margin/Scroll/List.get_children():
		child.queue_free()


func remove(id: String) -> void:
	if id in rules:
		rules.remove(rules.find(id))
		$Margin/Scroll/List.get_node(id).queue_free()
