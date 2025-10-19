extends Node


var _loggers: Dictionary = {}  # key: Logger name, value: Logger object


enum LogLevel {
	DEBUG,
	INFO,
	WARNING,
	ERROR
}


class HeroLogger:
	var logger_name: String = "default"
	var level = LogLevel.INFO
	
	func _init(new_logger_name: String):
		logger_name = new_logger_name
		
	func debug(message: String) -> void:
		if level in [LogLevel.DEBUG]:
			_log_message("DEBUG", message)
		
	func info(message: String) -> void:
		if level in [LogLevel.DEBUG, LogLevel.INFO]:
			_log_message("INFO", message)
	
	func warning(message: String) -> void:
		if level in [LogLevel.DEBUG, LogLevel.INFO, LogLevel.WARNING]:
			_log_message("WARNING", message)
		
	func error(message: String) -> void:
		if level in [LogLevel.DEBUG, LogLevel.INFO, LogLevel.WARNING, LogLevel.ERROR]:
			_log_message("ERROR", message)
			
	func _log_message(levelString: String, message: String) -> void:
		var dt=Time.get_datetime_dict_from_system()
		var timeString: String = "%s.%s.%s, %02d:%02d:%02d " % [dt.year, dt.month, dt.day, dt.hour,dt.minute,dt.second]
		
		print("%s: %s, %s, %s" % [timeString, logger_name, levelString, message])


func get_logger(logger_name: String = "default") -> HeroLogger:
	if not logger_name in _loggers:
		_loggers[logger_name] = HeroLogger.new(logger_name)
	return _loggers[logger_name]
