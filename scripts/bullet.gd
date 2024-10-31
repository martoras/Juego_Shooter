extends Sprite2D

var speed = 600  # Velocidad de la bala
var direction = Vector2.RIGHT  # Dirección por defecto

# Llama a esta función para establecer la dirección
func set_direction(dir: Vector2) -> void:
	direction = dir.normalized()  # Asegúrate de que la dirección esté normalizada

# Llamado cuando el nodo entra en el árbol de escenas por primera vez.
func _physics_process(delta: float) -> void:
	position += direction * speed * delta  # Mueve la bala en la dirección establecida

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
