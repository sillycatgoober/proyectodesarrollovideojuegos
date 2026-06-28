extends RichTextLabel
const CHARS_POR_SEGUNDO = 30
var tween_actual: Tween = null

func mostrar_texto(nuevo_texto: String) -> void:
	text = nuevo_texto
	visible_characters = 0
	
	if tween_actual:
		tween_actual.kill()
	
	tween_actual = create_tween()
	tween_actual.tween_property(self, "visible_characters", nuevo_texto.length(), nuevo_texto.length() / float(CHARS_POR_SEGUNDO))

func completar_texto() -> void:
	if tween_actual and tween_actual.is_running():
		tween_actual.kill()
		tween_actual = null
		visible_characters = len(text)
