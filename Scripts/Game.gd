extends Node3D

@export var move_speed: float = 5.0
@onready var player: CharacterBody3D = $Player
@onready var camera: Camera3D = $Camera3D
@onready var joystick: Control = $CanvasLayer/Joystick

func _physics_process(_delta: float) -> void:
    var input_vec: Vector2 = joystick.output_vector
    input_vec += Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    input_vec = input_vec.limit_length(1.0)

    # Camera-relative movement, projected onto the ground plane.
    var forward := -camera.global_basis.z
    forward.y = 0
    forward = forward.normalized()
    var right := camera.global_basis.x
    right.y = 0
    right = right.normalized()
    var direction := right * input_vec.x + forward * -input_vec.y

    player.velocity.x = direction.x * move_speed
    player.velocity.z = direction.z * move_speed
    player.velocity.y = 0.0
    player.move_and_slide()

func _process(_delta: float) -> void:
    var target := player.global_position + Vector3(0, 7, 10)
    camera.global_position = camera.global_position.lerp(target, 0.12)
    camera.look_at(player.global_position + Vector3(0, 0.4, 0), Vector3.UP)
