extends CanvasLayer
class_name GUI

var _move_vector: Vector2
var _rotation_angle: float

@export var joystick_left : VirtualJoystick
@export var joystick_right : VirtualJoystick


func _process(_delta: float) -> void:
	_move_vector = Vector2.ZERO
	_move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	if joystick_right and joystick_right.is_pressed:
		_rotation_angle = joystick_right.output.angle()
	else:
		_rotation_angle = 0.0


func get_movement_vector() -> Vector2:
	return _move_vector
	

func get_rotation_angle() -> float:
	return _rotation_angle
