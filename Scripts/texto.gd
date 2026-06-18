extends RichTextLabel

var mensaje_de_prueba = "Hola se Muy Bienvenido a la oficina qquieres jugar valoratr conmigo?"

func _ready():
	mostrar_texto(mensaje_de_prueba, 3.0)

func mostrar_texto(nuevo_texto: String, segundos: float):
	text = nuevo_texto
	visible_characters = 0
	
	var tween = create_tween()
	
	tween.tween_property(self, "visible_characters", nuevo_texto.length(), segundos)
