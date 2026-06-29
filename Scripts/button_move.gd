extends TextureButton

@export var desplazamiento := 8.0
@export var duracion := 0.15

var pos_original: Vector2
var tween: Tween

func _ready():
	pos_original = position

func _on_mouse_entered():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position:x", pos_original.x + desplazamiento, duracion)

func _on_mouse_exited():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position:x", pos_original.x, duracion)
