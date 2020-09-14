extends Control

var rules := []
var next_id := 0

func _ready() -> void:
	_load_rules()


func _load_rules() -> void:
	var file := File.new()
	if not file.file_exists("res://rules.rl"):
		return
	
	file.open("res://rules.rl",File.READ)
	rules = parse_json(file.get_as_text())
	for rule in rules:
		var node: RuleEdit = load("res://Rule.tscn").instance()
		node.initialize(rule)
		$Margin/Scroll/List.add_child(node)
		next_id = max(next_id, rule.id + 1)


func _save_rules() -> void:
	var file := File.new()
	file.open("res://rules.rl",File.WRITE)
	file.store_line(to_json(rules))


func _on_NewRule_pressed() -> void:
	var rule := {id = next_id}
	rules.append(rule)
	next_id += 1
	var node: RuleEdit = load("res://Rule.tscn").instance()
	node.initialize(rule)
	$Margin/Scroll/List.add_child(node)
	#$Margin/Scroll/List.
