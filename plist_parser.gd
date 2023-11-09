class_name PlistParser
## Class used for parsing .plist files.


static func parse_buffer(buffer: PackedByteArray) -> PlistFile:
	return PlistFile.new(XML.parse_buffer(buffer))


static func parse_file_path(file_path: String) -> PlistFile:
	return PlistFile.new(XML.parse_file(file_path))


static func parse_string(str: String) -> PlistFile:
	return PlistFile.new(XML.parse_str(str))
