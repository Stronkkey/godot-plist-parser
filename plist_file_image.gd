class_name PlistFileImage extends PlistFile

enum ImageKeyValuesOffset {
	ALIASES = 1,
	OFFSET = 3,
	SIZE = 5,
	SOURCE_SIZE = 7,
	TEXTURE_RECT = 9,
	ROTATED = 11
}

var image_atlases: Dictionary = {} # Key: String, Value: Dictionary


func _init(xml: XMLDocument) -> void:
	super._init(xml)

	for i in range(key_names.size()):
		_for_texture_atlas(i)


func _for_texture_atlas(index: int) -> void:
	var key_name: String = key_names[index]
	var node_key_values: Array[XMLNode] = key_values[index]
	var image_key_values: Dictionary = {
		"aliases": [],
		"offset": _string_to_vector2(node_key_values[ImageKeyValuesOffset.OFFSET].content, true),
		"size": _string_to_vector2(node_key_values[ImageKeyValuesOffset.SIZE].content, true),
		"source_size": _string_to_vector2(node_key_values[ImageKeyValuesOffset.SOURCE_SIZE].content, true),
		"texture_rect": _string_to_rect2(node_key_values[ImageKeyValuesOffset.TEXTURE_RECT].content),
		"rotated": true if node_key_values[ImageKeyValuesOffset.ROTATED].name == "true" else false
	}

	for alias in node_key_values[ImageKeyValuesOffset.ALIASES].children:
		image_key_values["aliases"].append(alias)

	image_atlases[key_name] = image_key_values
