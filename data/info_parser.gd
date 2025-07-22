extends Node
class_name InfoParser

var csv_file_path: String = "res://data/Info.csv"
var _col_name_image_name: String = "Art_deutsch"
var _data: Dictionary[String, Dictionary] = {}
var _logger: Logging.Logger


func _init():
	_logger = Logging.get_logger("InfoParser")
	_import_resources_data()


func get_info_of(image_name: String) -> Dictionary[String, String]:
	var clean_name = _validate_image_name(image_name)
	return _data[clean_name]


func _import_resources_data():
	var file: FileAccess = FileAccess.open(csv_file_path, FileAccess.READ)
	var idx_col_identifier: int = -1
	var idx_row: int = 0
	var data_array: Array[String]
	var name_identifier: String
	var fields: Array[String] = []
	
	while !file.eof_reached():
		data_array = _to_string_array(Array(file.get_csv_line()))
		if data_array.size() == 0:
			continue
			
		if idx_row == 0:
			idx_col_identifier = data_array.find(_col_name_image_name)
			fields = data_array
			
		elif data_array.size() != len(fields):
			continue
			
		else:
			name_identifier = data_array[idx_col_identifier]
			if not name_identifier:
				_logger.warning("Skipping row %s in input csv, latin name is empty" % idx_row)
				continue
			
			_data[name_identifier] = _parse_fields(fields, data_array)
		
		idx_row += 1
		
	file.close()


func _validate_image_name(img_name: String) -> String:
	var valid_name: String = img_name.split("/")[-1]  # Get Basename
	valid_name = valid_name.split(".")[0]  # Remove ending

	if valid_name not in _data.keys():
		valid_name = _safe_remove_tailing_number(valid_name)
		if valid_name not in _data.keys():
			valid_name = valid_name.replace("_", " ")
			if valid_name not in _data.keys():
				_logger.warning("Could validate filename for %s" % img_name)
				
	return valid_name


func _parse_fields(field_names: Array[String], data_array: Array[String]) -> Dictionary[String, String]:
	var dict: Dictionary[String, String] = {}
	for idx in range(len(field_names)):
		dict[field_names[idx]] = data_array[idx]
	return dict
	
	
func _to_string_array(array: Array) -> Array[String]:
	var str_arr: Array[String] = []
	for entry in array:
		str_arr.append(str(entry))
	return str_arr


func _safe_remove_tailing_number(fname: String) -> String:
	var parts: Array[String] = _to_string_array(fname.split("_"))
	if parts[-1].is_valid_int():
		parts.resize(parts.size() - 1)  # remove last part, i.e., the number
		fname = "_".join(parts)  # rejoin
	
	return fname
