extends Node
class_name InfoParser

var csv_file_path: String = "res://data/Info.csv"
var _col_name_image_name: String = "Art_latein"
var _data: Dictionary[String, Dictionary] = {}
var _logger: Logging.Logger

func _init():
	_logger = Logging.get_logger("InfoParser")
	import_resources_data()


func import_resources_data():
	var file: FileAccess = FileAccess.open(csv_file_path, FileAccess.READ)
	var idx_col_identifier: int = -1
	var idx_row: int = 0
	var data_array: Array[String]
	var name_latin: String
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
			name_latin = data_array[idx_col_identifier]
			if not name_latin:
				_logger.warning("Skipping row %s in input csv, latin name is empty" % idx_row)
				continue
			
			_data[name_latin] = _parse_fields(fields, data_array)
		
		idx_row += 1
		
	file.close()


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
