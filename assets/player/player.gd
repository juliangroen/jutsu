extends CharacterBody2D
class_name Player

@export var speed: int = PlayerConfig.base_speed

@onready var animation : Node2D = $NinjaDarkSprite

func get_input() -> void:
	var input_direction : Vector2 = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_pressed("left"):
		animation.play("left")
	velocity = input_direction * speed

func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()

