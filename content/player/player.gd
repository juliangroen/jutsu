extends CharacterBody2D
class_name Player

enum States {
	IDLE,
	WALKING,
	ATTACKING,
}
enum Directions {
	LEFT,
	DOWN,
	UP,
	RIGHT,
}

@export var speed := PlayerConfig.base_speed
@onready var animated_sprite := $NinjaDarkSprite

var state := States.IDLE : set = set_state
var direction := Directions.DOWN : set = set_direction

func set_state(new_state: States) -> void:
	if state == States.ATTACKING:
		await animated_sprite.animation_finished

	state = new_state

func set_direction(new_direction: Directions) -> void:
	direction = new_direction

func get_input() -> void:
	var input_direction := Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

	match input_direction:
		Vector2.LEFT:
			set_direction(Directions.LEFT)
		Vector2.DOWN:
			set_direction(Directions.DOWN)
		Vector2.UP:
			set_direction(Directions.UP)
		Vector2.RIGHT:
			set_direction(Directions.RIGHT)

	if Input.is_action_just_released("attack"):
		set_state(States.ATTACKING)

	if input_direction == Vector2.ZERO:
		set_state(States.IDLE)
	else:
		set_state(States.WALKING)

func handle_animation() -> void:

	var direction_string : String = Directions.find_key(direction).to_lower()
	if state == States.ATTACKING:
		animated_sprite.play("attack_%s" % direction_string)
	elif state == States.WALKING:
		animated_sprite.play("walk_%s" % direction_string)
	elif state == States.IDLE:
		animated_sprite.play("idle_%s" % direction_string)

func _physics_process(_delta: float) -> void:
	get_input()
	handle_animation()
	move_and_slide()
