class_name FloatingDamageNumber extends Label3D

func setup(amount: float) -> void:
	text = str(int(amount))
	if amount >= 30.0:
		font_size = 48
	elif amount >= 15.0:
		font_size = 40
	else:
		font_size = 32
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y + 1.5, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "modulate:a", 0.0, 0.8).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.chain().tween_callback(queue_free)
