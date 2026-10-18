extends Node2D

@onready var bgs = [$background, $Background2, $Background3]
@onready var timer = $Timer

var current = 0

func _ready() -> void:
	for i in range(bgs.size()):
		bgs[i].visible = (i == 0)
	timer.timeout.connect(_change_background)
	
func _change_background():
	bgs[current].visible = false
	current = (current + 1) % bgs.size()
	bgs[current].visible = true


func _on_button_pressed() -> void:
	pass # Replace with function body.
