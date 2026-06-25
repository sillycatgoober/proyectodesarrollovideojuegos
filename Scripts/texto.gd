extends RichTextLabel

func mostrar_texto(nuevo_texto: String, segundos: float) -> void:
	text = nuevo_texto
	visible_characters = 0
	
	var tween = create_tween()
	tween.tween_property(self, "visible_characters", nuevo_texto.length(), segundos)
