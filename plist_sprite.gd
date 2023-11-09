@tool
extends Sprite2D
class_name PlistSprite2D
## Class used for loading a TextureAtlas from a .plist file.

@export var plist_path: StringName:
	set = set_plist_path,
	get = get_plist_path
@export var sprite_name: StringName:
	set = set_sprite_name,
	get = get_sprite_name

var _plist_file_image: PlistFileImage


func _ready() -> void:
	region_enabled = true
	_set_region()


func _set_region() -> void:
	if not _plist_file_image:
		return

	var image_atlas: Dictionary = _plist_file_image.image_atlases.get(sprite_name, {})
	var texture_rect: Rect2 = image_atlas.get("texture_rect", Rect2(Vector2.ZERO, Vector2.ZERO))
	var texture_offset: Vector2 = image_atlas.get("offset", Vector2.ZERO)
	var rotated: bool = image_atlas.get("rotated", false)

	if rotated:
		var old_size_x: float = texture_rect.size.x
		var old_offset_x: float = texture_offset.x
		texture_rect.size.x = texture_rect.size.y
		texture_rect.size.y = old_size_x
		texture_offset.x = texture_offset.y * -1
		texture_offset.y = old_offset_x * -1
		rotation_degrees = -90
	else:
		rotation_degrees = 0
		texture_offset.x *= -1

	offset = texture_offset
	region_rect = texture_rect


func set_plist_path(value: StringName) -> void:
	plist_path = value

	if FileAccess.file_exists(value):
		_plist_file_image = PlistFileImage.new(XML.parse_file(value))
		_set_region()


func get_plist_path() -> StringName:
	return plist_path


func set_sprite_name(value: StringName) -> void:
	sprite_name = value
	_set_region()


func get_sprite_name() -> StringName:
	return sprite_name
