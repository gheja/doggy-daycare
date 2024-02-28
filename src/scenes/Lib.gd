extends Node

func get_first_group_member(group_name):
	var members = get_tree().get_nodes_in_group(group_name)
	
	if members.size() == 0:
		print("Warning: No object matching group \"", group_name, "\", returning null.")
		return null
	
	return members[0]

func array_pick(a):
	return a[randi() % a.size()]

func get_player_object():
	return Lib.get_first_group_member("player_characters")

func get_narrator_object():
	return Lib.get_first_group_member("narrators")

func silence(_value):
	return

func dist_2d(p1, p2):
	return abs((p1 - p2).length())
