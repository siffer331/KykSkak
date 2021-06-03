extends Control

onready var in_play: Node = $Margin/DragSplit/DragSplit/InPlay
onready var rules: Node = $Margin/DragSplit/Rules

var timer_variation := 15
var timer_time := 60

var current_rule : Dictionary

func _ready():
	randomize()
	$AcceptRule.get_cancel().text = "Decline"
	$AcceptRule.add_button("Wait").connect("pressed", self, "_on_Wait_pressed")


func _process(delta: float) -> void:
	$Margin/DragSplit/DragSplit/Settings/Margin/List/Progress.value = 100 - $Timer.time_left*100/$Timer.wait_time


func _on_Timer_timeout():
	$AudioStreamPlayer.play()
	_new_rule()

func _new_rule():
	current_rule = rules.get_rule()
	if current_rule:
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


func _on_Start_pressed():
	rules.start_game()
	in_play.reset()
	_new_rule()


func _on_Stop_pressed():
	$Timer.stop()


func _on_NewRule_pressed():
	if $Timer.time_left > 0:
		$Timer.stop()
		_new_rule()
