extends Node

func play():
	var players = $RandomSounds.get_children()
	players.shuffle()
	players[0].play()
