extends Node

func is_inside_area(area: Area2D, player: Node2D) -> bool:
	return area.get_overlapping_bodies().has(player)
