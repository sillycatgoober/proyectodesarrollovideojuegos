extends Node3D
@export var puerta_bib1: Node
@export var puerta_bib2: Node
@export var puerta_sal1: Node
@export var puerta_sal2: Node
@export var pupitre: Node
@onready var anim_ojos = $AnimOjos
@onready var audio = $SFX
var relojes_correctos := {0: false, 1: false, 2: false}

func _ready() -> void:
	GameManager.Fase.SUENO
	GameManager.guardar()
	UI.leave_menu.visible = false
	for reloj in get_tree().get_nodes_in_group("reloj"):
		reloj.reloj_confirmado.connect(_on_reloj_confirmado.bind(reloj.id_reloj))
	InventoryManager.item_added.connect(_on_carta_agregada)
	pupitre.carta_colocada.connect(_on_carta_colocada)
	anim_ojos.visible = true
	anim_ojos.play("open")
	await anim_ojos.animation_finished
	anim_ojos.visible = false

func _on_reloj_confirmado(id: int) -> void:
	relojes_correctos[id] = true
	print("Reloj ", id, " correcto")
	verificar_todos()

func verificar_todos() -> void:
	if relojes_correctos.values().all(func(v): return v):
		audio.play()
		UI.set_hints("La campana... Tal vez cambió algo.")
		abrir_biblioteca()

func abrir_biblioteca() -> void:
	puerta_bib1.desbloquear()
	puerta_bib2.desbloquear()

func _on_carta_colocada():
	puerta_sal1.desbloquear_salida()
	puerta_sal2.desbloquear_salida()

	GameManager.dreams["1"].done = true

func _on_carta_agregada(item_id):
	if item_id == "carta":
		pupitre.desbloquear()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		GameManager.fase_actual = GameManager.Fase.DIAGNOSTICO
		GameManager.guardar()
		get_tree().change_scene_to_file("res://Scenes/office.tscn")
		#TransitionManager.play_transition("res://Scenes/Interview/interview.tscn")
