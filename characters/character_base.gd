extends Node2D

@export var speed: float = 100.0

@onready var gui: GUI = $GUI
@onready var character_sprite: Sprite2D = $CharacterSprite


func _process(delta: float) -> void:
	position += gui.get_movement_vector() * speed * delta
	rotation = gui.get_rotation_angle()
