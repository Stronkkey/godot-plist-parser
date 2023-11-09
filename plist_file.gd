class_name PlistFile extends Resource
## A resource that represents a .plist file.

var key_names: PackedStringArray = []
var key_values: Array = []


func _init(xml: XMLDocument) -> void:
	var dict_keys: Array[XMLNode] = xml.root.children[0].children
	var i: int = 0

	for node in dict_keys[1].children:
		i += 1
		if i % 2 == 0:
			_for_plist_frame_key_values(node)
		else:
			_for_plist_frame_key_name(node)


func _for_plist_frame_key_name(node: XMLNode) -> void:
	key_names.append(node.content)


func _for_plist_frame_key_values(node: XMLNode) -> void:
	key_values.append(node.children)


func _string_to_vector2(string: String, inverse_values: bool = false) -> Vector2:
	var vector_values: PackedStringArray = string.trim_prefix("{").trim_suffix("}").split(",")

	for i in range(vector_values.size()):
		if not vector_values[i].is_valid_float():
			vector_values[i] = "0.0"
		elif inverse_values:
			vector_values[i] = str(vector_values[i].to_float() * -1)

	return Vector2(vector_values[0].to_float(), vector_values[1].to_float()) if vector_values.size() >= 2 else Vector2.ZERO


func _string_to_rect2(string: String) -> Rect2:
	var rect_values: PackedStringArray = string.trim_prefix("{{").trim_suffix("}}").split("},{")
	return Rect2(_string_to_vector2(rect_values[0]), _string_to_vector2(rect_values[1])) if rect_values.size() >= 2 else Rect2()
