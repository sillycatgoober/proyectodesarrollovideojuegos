extends Interactuable

func interact() -> void:
	var player = get_player()
	
	if player:
		player.tiene_carta = true
		print( "la carta de disculpa")
		
		
		
		queue_free()
