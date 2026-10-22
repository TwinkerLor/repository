extends Control

func _ready() -> void:
	anchors_preset = Control.PRESET_FULL_RECT
	size = get_viewport_rect().size
	$MarginContainer/HBoxContainer/RightPanel/AudioPanel.visible = true
	$MarginContainer/HBoxContainer/RightPanel/VideoPanel.visible = false
	$MarginContainer/HBoxContainer/RightPanel/AudioPanel/HSlider.value = AudioServer.get_bus_volume_db(0)

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_audio_pressed() -> void:
	$MarginContainer/HBoxContainer/RightPanel/AudioPanel.visible = true
	$MarginContainer/HBoxContainer/RightPanel/VideoPanel.visible = false

func _on_video_pressed() -> void:
	$MarginContainer/HBoxContainer/RightPanel/AudioPanel.visible = false
	$MarginContainer/HBoxContainer/RightPanel/VideoPanel.visible = true

func _on_back_pressed() -> void:
	queue_free()
