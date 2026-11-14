extends CharacterBody2D

const SPEED = 600.0

@export var projectile_scene: PackedScene
@export var shoot_speed: float = 750.0
@export var shoot_interval: float = 3.0
@export var max_health: int = 100

var current_health: int
var shoot_timer: float = 0.0

@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar


func _ready() -> void:
	current_health = max_health
	health_bar.max_value = max_health
	health_bar.value = current_health


func take_damage(amount: int) -> void:
	current_health = max(0, current_health - amount)
	health_bar.value = current_health
	if current_health <= 0:
		get_tree().reload_current_scene()


func shoot() -> void:
	if projectile_scene == null:
		return
		
	var proj = projectile_scene.instantiate()
	get_tree().current_scene.add_child(proj)
	proj.global_position = global_position
	
	var random_angle = randf_range(0.0, TAU)
	var shoot_direction = Vector2.RIGHT.rotated(random_angle)
	proj.linear_velocity = shoot_direction * shoot_speed


func _physics_process(delta: float) -> void:
	shoot_timer += delta
	if shoot_timer >= shoot_interval:
		shoot_timer = 0.0
		shoot()
	
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("jump"):
		velocity.y = -SPEED
	elif Input.is_action_pressed("down"):
		velocity.y = SPEED
		
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		
	move_and_slide()
