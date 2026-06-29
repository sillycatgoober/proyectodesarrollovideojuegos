extends CanvasLayer
class_name Transicion
@onready var anim_player: AnimationPlayer = $AnimationPlayer
signal animation_finished

func play(nombre: String) -> void:
	anim_player.play(nombre)

func _ready() -> void:
	anim_player.animation_finished.connect(func(anim): animation_finished.emit())
