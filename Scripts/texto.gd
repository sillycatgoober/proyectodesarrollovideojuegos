extends RichTextLabel
#const CHARS_POR_SEGUNDO = 30
#var tween_actual: Tween = null
#
#func mostrar_texto(nuevo_texto: String) -> void:
	#text = nuevo_texto
	#visible_characters = 0
	#
	#if tween_actual:
		#tween_actual.kill()
	#
	#tween_actual = create_tween()
	#tween_actual.tween_property(self, "visible_characters", nuevo_texto.length(), nuevo_texto.length() / float(CHARS_POR_SEGUNDO))
#
#func completar_texto() -> void:
	#if tween_actual and tween_actual.is_running():
		#tween_actual.kill()
		#tween_actual = null
		#visible_characters = len(text)

const CHARS_POR_SEGUNDO := 30.0
var escribiendo := false
var sonido := AudioStreamPlayer.new()
var sonidos := [
	preload("res://Assets/Audio/SFX/talk1.wav"),
	preload("res://Assets/Audio/SFX/talk2.wav"),
	preload("res://Assets/Audio/SFX/talk3.wav"),
	preload("res://Assets/Audio/SFX/talk4.wav")
]

func _ready():
	add_child(sonido)

func mostrar_texto(nuevo_texto: String) -> void:
	escribiendo = false
	await get_tree().process_frame

	text = nuevo_texto
	visible_characters = 0
	escribiendo = true

	for i in nuevo_texto.length():
		if !escribiendo:
			return

		visible_characters += 1
		var letra = nuevo_texto[i]

		if letra != " " and letra != "\n":
			sonido.stream = sonidos.pick_random()
			sonido.pitch_scale = randf_range(0.95, 1.05)
			sonido.play()

		await get_tree().create_timer(1.0 / CHARS_POR_SEGUNDO).timeout
	completar_texto()

func detener_texto():
	escribiendo = false

func completar_texto():
	escribiendo = false
	visible_characters = text.length()
