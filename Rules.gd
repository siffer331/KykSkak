extends Control

var rules := {}
var next_id := 0

onready var list: VBoxContainer = $Margin/Scroll/List

func _ready() -> void:
	randomize()
	_load_rules()


func get_rule() -> Dictionary:
	var possible := []
	for id in rules:
		if not rules[id].disabled:
			possible.append(id)
	return rules[possible[randi()%len(possible)]]


func disable_rule(id: String) -> void:
	rules[id].disabled = true
	$Margin/Scroll/List.get_node(id).disable(true)


func _load_rules() -> void:
	var file := File.new()
	if not file.file_exists("res://rules.rl"):
		return
	
	file.open("res://rules.rl",File.READ)
	rules = parse_json(file.get_as_text())
	for id in rules:
		_place_rule(rules[id])
		next_id = max(next_id, int(id) + 1)


func _save_rules() -> void:
	var file := File.new()
	file.open("res://rules.rl",File.WRITE)
	file.store_line(to_json(rules))


func _place_rule(rule: Dictionary) -> void:
	var node: RuleEdit = load("res://Rule.tscn").instance()
	node.initialize(rule)
	list.add_child(node)
	list.move_child(node, list.get_child_count()-2)
	node.connect("updated_data", self, "_on_Rule_updated_data")
	node.connect("removed", self, "_on_Rule_removed")


func _on_NewRule_pressed() -> void:
	var rule := {id = str(next_id), name = "New rule", description = "New rule", disabled = false}
	rules[str(next_id)] = rule
	next_id += 1
	_place_rule(rule)


func _on_Rule_updated_data(data: Dictionary) -> void:
	rules[data.id] = data
	_save_rules()


func _on_Rule_removed(id: int) -> void:
	rules.erase(id)
	_save_rules()
