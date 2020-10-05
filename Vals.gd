extends Node

signal names_changed

var names := {} setget _set_names

func _set_names(val: Dictionary):
	names = val
	emit_signal("names_changed")
