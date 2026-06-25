extends Control

func _ready():
	$AnimationPlayer.play("dream_exit")
	await $AnimationPlayer.animation_finished

	get_tree().change_scene_to_file(TransitionManager.next_scene)
