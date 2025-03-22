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

var state_map = {
	States.IDLE: "idle",
	States.WALKING: "walking",
	States.ATTACKING: "attacking",
}

var direction_map = {
	Directions.LEFT: "left",
	Directions.DOWN: "down",
	Directions.UP: "up",
	Directions.RIGHT: "right",
}

var state := States.IDLE : set = set_state
var direction := Directions.DOWN : set = set_direction

@export var speed := PlayerConfig.base_speed
# @export var direction := "down"
@export var is_moving := false

@onready var animated_sprite := $NinjaDarkSprite

func set_state(new_state: States) -> void:
	# var previous_state := state
	if state == States.ATTACKING:
		await animated_sprite.animation_finished

	state = new_state

func set_direction(new_direction: Directions) -> void:
	# var previous_direction := direction
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

	if state == States.ATTACKING:
		animated_sprite.play("attack_%s" % direction_map[direction])
	elif state == States.WALKING:
		animated_sprite.play("walk_%s" % direction_map[direction])
	elif state == States.IDLE:
		animated_sprite.play("idle_%s" % direction_map[direction])

func _physics_process(_delta: float) -> void:
	get_input()
	handle_animation()
	move_and_slide()
	print(state_map[state])
