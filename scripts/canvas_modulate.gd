extends CanvasModulate

func _ready() -> void:
	SettingsManager.set_brightness_layer(self)
