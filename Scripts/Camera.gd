# Source script - Copyright (c) 2018 Jaccomo Lorenz (Maujoe)
# MIT License.

extends Camera

export var mouselook = true
export (float, 0.0, 1.0) var sensitivity = 0.5
export (float, 0.0, 0.999, 0.001) var smoothness = 0.5 setget set_smoothness
export(NodePath) var privot setget set_privot
export var rotate_privot = false
export (int, 0, 0) var yaw_limit = 0
export (int, 0, 45) var pitch_limit = 75

var _mouse_position = Vector2(0.0, 0.0)
var _yaw = 0.0
var _pitch = 0.0
var _total_yaw = 0.0
var _total_pitch = 0.0


func _input(event):
	if mouselook:
		if event is InputEventMouseMotion:
			_mouse_position = event.relative


func _physics_process(delta):
	if mouselook:
		_update_mouselook()


func _update_mouselook():
	_mouse_position *= sensitivity
	_pitch = _pitch * smoothness + _mouse_position.y * (1.0 - smoothness)
	_mouse_position = Vector2(0, 0)

	if yaw_limit < 360:
		_yaw = clamp(_yaw, -yaw_limit - _total_yaw, yaw_limit - _total_yaw)
	if pitch_limit < 360:
		_pitch = clamp(_pitch, -pitch_limit - _total_pitch, pitch_limit - _total_pitch)

	_total_yaw += _yaw
	_total_pitch += _pitch

	if privot:
		var target = privot.get_translation()
		var offset = get_translation().distance_to(target)

		set_translation(target)
		rotate_y(deg2rad(-_yaw))
		rotate_object_local(Vector3(1,0,0), deg2rad(-_pitch))
		translate(Vector3(0.0, 0.0, offset))

		if rotate_privot:
			privot.rotate_y(deg2rad(-_yaw))
	else:
		rotate_y(deg2rad(-_yaw))
		rotate_object_local(Vector3(1,0,0), deg2rad(-_pitch))


func set_privot(value):
	privot = value


func set_smoothness(value):
	smoothness = clamp(value, 0.001, 0.999)

