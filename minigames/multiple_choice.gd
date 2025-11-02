extends Control
class_name MultipleChoiceGame

@onready var _grid: GridContainer = $GridContainer
var _sprites: Array[TextureRect] = []


func _ready():
	_clear_sprites()
	var texture_rect: TextureRect
	var img_textures: Array[ImageTexture] = await DataRetriever.get_images_of("gaemswurz")
	for img_tex in img_textures:
		img_tex.set_size_override(Vector2(256.0, 256.0))
		texture_rect = TextureRect.new()
		texture_rect.texture = img_tex
		_grid.add_child(texture_rect)
		

func _clear_sprites() -> void:
	for sprite in _sprites:
		sprite.queue_free()
	
	_sprites = []
