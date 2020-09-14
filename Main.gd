extends Control

onready var in_play: Node = $Margin/DragSplit/DragSplit/InPlay
onready var rules: Node = $Margin/DragSplit/Rules

func _ready():
	_new_rule()


func _on_Timer_timeout():
	_new_rule()

func _new_rule():
	var current_rule : Dictionary = {name = "regel navn"}#(midlertidig dictiornary. Regler skal komme fra get_rule funktionen i rules noden)rules.get_rule()
	$ConfirmationDialog/Text.text = "Vil du acceptere reglen:\n" + current_rule.name
	$ConfirmationDialog.popup()


