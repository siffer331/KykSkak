extends Control

onready var in_play: Node = $Margin/DragSplit/DragSplit/InPlay
onready var rules: Node = $Margin/DragSplit/Rules

var timer_variation := 5
var timer_time := 10

var current_rule : Dictionary

func _ready():
	randomize()
	_new_rule()
	$AcceptRule.add_button("Wait").connect("pressed", self, "_on_Wait_pressed")
	$AcceptRule.get_close_button()


func _process(delta: float) -> void:
	$Margin/DragSplit/DragSplit/Settings/Margin/List/Progress.value = 100 - $Timer.time_left*100/$Timer.wait_time


func _on_Timer_timeout():
	_new_rule()

func _new_rule():
	current_rule = rules.get_rule()
	$AcceptRule/Text.text = "Vil du acceptere reglen:\n" + current_rule.name
	$AcceptRule/Text.hint_tooltip = current_rule.description
	$AcceptRule.popup()


func _wait_for_rule() -> void:
	$Timer.wait_time = max(0.1,timer_time + randi()%(2*timer_variation) - timer_variation)
	$Timer.start()


func _on_AcceptRule_confirmed():
	rules.put_rule_in_game(current_rule.id)
	in_play.add(current_rule.name, current_rule.description, current_rule.id)
	$Timer.start()
	current_rule = {}
	_wait_for_rule()


func _on_AcceptRule_popup_hide():
	yield(get_tree(), "idle_frame")
	if current_rule:
		$Timer.wait_time = .2
		$Timer.start()


func _on_Wait_pressed() -> void:
	current_rule = {}
	_wait_for_rule()
	$AcceptRule.hide()
