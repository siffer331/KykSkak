extends Control

var rules := []


func add(rule: String, id: int) -> void:
	rules.append(id)
	var label := Label.new()
	label.name = str(id)
	label.autowrap = true
	$List.add_child(label)


func remove(id: int) -> void:
	if id in rules:
		rules.remove(rules.find(id))
		get_node("List/"+str(id)).queue_free()
