extends Node

var dream_actual := 1
var dreams = {
	1: {"done": false},
	2: {"done": false},
	3: {"done": false},
	4: {"done": false},
	5: {"done": false}
}

func reset_dreams():
	dream_actual = 1
	dreams = {
		1: {"done": false},
		2: {"done": false},
		3: {"done": false},
		4: {"done": false},
		5: {"done": false}
	}

func guardar():
	var data = {
		"dreams": dreams,
		"dream_actual": dream_actual
	}

func cargar(data):
	dreams = data.dreams
	dream_actual = data.dream_actual
