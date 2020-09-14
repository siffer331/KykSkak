extends Control

onready var in_play: Node = $Margin/DragSplit/DragSplit/InPlay
onready var rules: Node = $Margin/DragSplit/Rules

var current_rule : Dictionary

func _ready():
	_new_rule()


func _on_Timer_timeout():
	_new_rule()

func _new_rule():
	current_rule = rules.get_rule()
	$AcceptRule/Text.text = "Vil du acceptere reglen:\n" + current_rule.name
	$AcceptRule.popup()


func _on_AcceptRule_confirmed():
	#rules.disable_rule(current_rule.id)
	pass
