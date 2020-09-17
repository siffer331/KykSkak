extends Control

var rules := []


func add(rule: String, description: String, id: String) -> void:
	rules.append(id)
	var label := Label.new()
	label.name = id
	label.text = rule
	label.autowrap = true
	label.hint_tooltip = description
	$Margin/List.add_child(label)


func remove(id: String) -> void:
	if id in rules:
		rules.remove(rules.find(id))
		get_node("List/"+id).queue_free()
