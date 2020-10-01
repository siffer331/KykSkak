extends Control

var default_rule := {id = 0, name = "New rule", description = "New rule", disabled = false, avaliable = 0}

var rules := {}
var next_id := 0
var game := []
var usable := 0 setget _set_usable

onready var list: VBoxContainer = $Margin/Split/Scroll/List

func _ready() -> void:
	randomize()
	_load_rules()


func start_game() -> void:
	game = []
	for id in rules:
		list.get_node(id).in_game = false


func get_rule() -> Dictionary:
	var possible := []
	for id in rules:
		if not rules[id].disabled and not id in game and len(game) >= rules[id].avaliable:
			possible.append(id)
	self.usable = len(possible)
	if len(possible) == 0:
		return {}
	return rules[possible[randi()%len(possible)]]


func disable_rule(id: String) -> void:
	rules[id].disabled = true
	list.get_node(id).disable(true)


func put_rule_in_game(id: String) -> void:
	self.usable -= 1 - int(rules[id].disabled)
	game.append(id)
	list.get_node(id).in_game = true


func _load_rules() -> void:
	var file := File.new()
	if OS.has_feature("standalone") and file.file_exists("user://rules.rls"):
		file.open("user://rules.rls", File.READ)
	else:
		file.open("res://rules.rls", File.READ)
	rules = parse_json(file.get_as_text())
	for id in rules:
		for key in default_rule:
			if not key in rules[id]:
				rules[id][key] = default_rule[key]
		_place_rule(rules[id])
		next_id = max(next_id, int(id) + 1)


func _save_rules() -> void:
	var file := File.new()
	file.open("res://rules.rls", File.WRITE)
	if not OS.has_feature("standalone"):
		file.open("res://rules.rls", File.WRITE)
	else:
		file.open("user://rules.rls", File.WRITE)
	file.store_line(to_json(rules))


func _place_rule(rule: Dictionary) -> void:
	self.usable += 1 - int(rule.disabled)
	var node: RuleEdit = load("res://Rule.tscn").instance()
	node.initialize(rule.duplicate())
	list.add_child(node)
	list.move_child(node, list.get_child_count()-2)
	node.connect("updated_data", self, "_on_Rule_updated_data")
	node.connect("removed", self, "_on_Rule_removed")


func _set_usable(val: int) -> void:
	usable = val
	$Margin/Split/Label.text = str(usable)+"/"+str(len(rules))


func _on_NewRule_pressed() -> void:
	var rule := default_rule.duplicate()
	rule.id = str(next_id)
	rules[str(next_id)] = rule
	next_id += 1
	_place_rule(rule)


func _on_Rule_updated_data(data: Dictionary) -> void:
	self.usable += int(rules[data.id].disabled) - int(data.disabled)
	rules[data.id] = data.duplicate()
	_save_rules()


func _on_Rule_removed(id: String) -> void:
	rules.erase(id)
	_save_rules()
