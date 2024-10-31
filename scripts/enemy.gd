extends Node2D



func _on_area_2d_area_entered(area: Area2D) -> void:
	area.get_parent().queue_free()
	queue_free()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Asegúrate de que el jugador esté en el grupo "player"
		# Lógica para matar al jugador
		print("¡El jugador ha sido tocado por el enemigo!")
		body.queue_free()  # Esto eliminará al jugador; puedes hacer otras acciones como restar vida, etc.
		get_tree().reload_current_scene()
