extends Control
class_name MultipleChoiceGame


var _parser: InfoParser

func _ready() -> void:
	_parser = InfoParser.new()
	print(_parser._data)
