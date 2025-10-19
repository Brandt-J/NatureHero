extends Control
class_name MultipleChoiceGame


var _parser: InfoParser
var _image_fnames: Array[String] = []


func _ready() -> void:
	pass
	#_parser = InfoParser.new()
	#_image_fnames = get_images("res://data/plants/")
	#for img_name in _image_fnames:
		#print(_parser.get_info_of(img_name))


func get_images(path: String, ignore_patterns: Array[String] = [".import"]) -> Array[String]:
	var dir: DirAccess = DirAccess.open(path)
	var img_fnames: Array[String] = []
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				img_fnames += get_images(path + file_name)
			else:
				if _is_valid_file(file_name, ignore_patterns):
					img_fnames.append(path + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	return img_fnames


func _is_valid_file(fname: String, anti_patterns: Array[String]) -> bool:
	var valid: bool = true
	for pattern in anti_patterns:
		if fname.ends_with(pattern):
			valid = false
			break
	return valid
