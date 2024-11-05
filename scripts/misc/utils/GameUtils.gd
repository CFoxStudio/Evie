extends Node

# Checks if a player is in area (Used mainly for interactions or scene transitions/teleports)
func is_inside_area(area: Area2D, player: Node2D) -> bool:
	return area.get_overlapping_bodies().has(player)
