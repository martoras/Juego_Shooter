extends CharacterBody2D

@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_timer: Timer = $ShootTimer  # **Asegúrate de que este Timer esté en tu escena**

var b
var is_shooting = false  # **Variable para controlar el estado de disparo**

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _ready():
	add_to_group("player")  # Agregar el jugador al grupo "player"
	
	if shoot_timer:
		shoot_timer.wait_time = 0.6  # **Establecer un tiempo de espera para el disparo**
		shoot_timer.one_shot = true  # **Hacer que el temporizador se detenga después de una vez**
		shoot_timer.connect("timeout", Callable(self, "_on_shoot_timer_timeout"))  # **Conectar el temporizador correctamente**
	else:
		print("Error: ShootTimer no se encontró en la escena.")  # **Mensaje de error si no se encuentra el Timer**

func shoot():
	if Input.is_action_just_pressed("shoot") and not is_shooting:  # **Verificar si no está disparando**
		is_shooting = true  # **Marcar que está disparando**
		animated_sprite.play("shoot")  # **Reproducir la animación de disparo**
		shoot_timer.start()  # **Iniciar el temporizador para el disparo**

func _on_shoot_timer_timeout():
	# **Instanciar y añadir la bala después del temporizador**
	b = bullet_scene.instantiate()
	get_parent().add_child(b)
	b.global_position = $Marker2D_Right.global_position
	
	# Establecer la dirección de la bala según hacia donde mire el jugador
	if animated_sprite.flip_h:
		b.set_direction(Vector2.LEFT)  # Izquierda
	else:
		b.set_direction(Vector2.RIGHT)  # Derecha
	
	is_shooting = false  # **Permitir disparar de nuevo**

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# **Controlar las animaciones según el estado de disparo**
	if is_shooting:
		# **No cambiar a otra animación si está disparando**
		return
	else:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	shoot()
