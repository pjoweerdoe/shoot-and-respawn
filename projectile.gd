extends RigidBody2D

@export var constant_speed: float = 750.0
@export var damage: int = 20

var can_hurt_player: bool = false

@onready var hitbox: Area2D = $Hitbox


func _ready() -> void:
	hitbox.body_entered.connect(_on_hitbox_body_entered)
	await get_tree().create_timer(0.25).timeout
	can_hurt_player = true


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if state.linear_velocity.length() > 0.0:
		state.linear_velocity = state.linear_velocity.normalized() * constant_speed


func _on_hitbox_body_entered(body: Node2D) -> void:
	if can_hurt_player and body.has_method("take_damage"):
		body.take_damage(damage)
