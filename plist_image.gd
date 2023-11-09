@tool
extends Texture2D
class_name PlistImage

@export var texture_atlas: Texture2D:
	set = set_texture_atlas,
	get = get_texture_atlas
@export var plist_path: StringName:
	set = set_plist_path,
	get = get_plist_path
@export var sprite_name: StringName:
	set = set_sprite_name,
	get = get_sprite_name

var _plist_file_image: PlistFileImage


func _is_texture_atlas_valid() -> bool:
	return texture_atlas is Texture2D


func _get_rid() -> RID:
	return texture_atlas.get_rid() if _is_texture_atlas_valid() else RID()


func _has_alpha() -> bool:
	return texture_atlas.has_alpha() if _is_texture_atlas_valid() else false


func _get_width() -> int:
	return texture_atlas.get_width() if _is_texture_atlas_valid() else 0


func _get_height() -> int:
	return texture_atlas.get_height() if _is_texture_atlas_valid() else 0


func _get_absolute_sprite_rect() -> Rect2:
	var image_atlas: Dictionary = _plist_file_image.image_atlases.get(sprite_name, {})
	return image_atlas.get("texture_rect", Rect2(Vector2.ZERO, Vector2.ZERO))


func _get_absolute_sprite_offset() -> Vector2:
	var image_atlas: Dictionary = _plist_file_image.image_atlases.get(sprite_name, {})
	return image_atlas.get("offset", Vector2.ZERO)


func _is_rotated() -> bool:
	var image_atlas: Dictionary = _plist_file_image.image_atlases.get(sprite_name, {})
	return image_atlas.get("rotated", false)


func _draw(to_canvas_item: RID, pos: Vector2, modulate: Color, transpose: bool) -> void:
	if not _is_texture_atlas_valid() or not _plist_file_image:
		return

	var texture_rect: Rect2 = _get_absolute_sprite_rect()
	var texture_offset: Vector2 = _get_absolute_sprite_offset() + pos
	var rotated: bool = _is_rotated()

	if rotated:
		var old_rect_x: float = texture_rect.size.x
		var old_offset_x: float = texture_offset.x
		texture_rect.size.x = texture_rect.size.y
		texture_rect.size.y = old_rect_x
		texture_offset.x = texture_offset.y * -1
		texture_offset.y = old_offset_x * -1
	else:
		texture_offset.x *= -1

	texture_atlas.draw_rect_region(to_canvas_item,
		Rect2(texture_offset - texture_rect.size / 2,
		texture_rect.size), texture_rect,
		modulate,
		rotated,
		false)


func _draw_rect(to_canvas_item: RID, _rect: Rect2, _tile: bool, modulate: Color, transpose: bool) -> void:
	if not _is_texture_atlas_valid() or not _plist_file_image:
		return

	var texture_rect: Rect2 = _get_absolute_sprite_rect()
	var texture_offset: Vector2 = _get_absolute_sprite_offset()
	var rotated: bool = _is_rotated()

	if rotated:
		var old_rect_x: float = texture_rect.size.x
		var old_offset_x: float = texture_offset.x
		texture_rect.size.x = texture_rect.size.y
		texture_rect.size.y = old_rect_x
		texture_offset.x = texture_offset.y * -1
		texture_offset.y = old_offset_x * -1
		texture_rect.size.y *= -1
	else:
		texture_offset.x *= -1

	texture_atlas.draw_rect_region(to_canvas_item,
		Rect2(texture_offset - texture_rect.size / 2,
		texture_rect.size), texture_rect,
		modulate,
		rotated,
		false)


func _draw_rect_region(to_canvas_item: RID, rect: Rect2, src_rect: Rect2, modulate: Color, transpose: bool, clip_uv: bool) -> void:
	if not _is_texture_atlas_valid() or not _plist_file_image:
		return

	texture_atlas.draw_rect_region(to_canvas_item, rect, src_rect, modulate, transpose, clip_uv)


func set_texture_atlas(value: Texture2D) -> void:
	texture_atlas = value


func get_texture_atlas() -> Texture2D:
	return texture_atlas


func set_plist_path(value: StringName) -> void:
	plist_path = value

	if FileAccess.file_exists(value):
		_plist_file_image = PlistFileImage.new(XML.parse_file(value))


func get_plist_path() -> StringName:
	return plist_path


func set_sprite_name(value: StringName) -> void:
	sprite_name = value


func get_sprite_name() -> StringName:
	return sprite_name
