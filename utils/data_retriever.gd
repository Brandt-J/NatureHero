extends Node

signal _Request_Completed

@onready var _requester: HTTPRequest = $HTTPRequest
@onready var _logger: Logging.HeroLogger = Logging.get_logger("DataRetriever")
var t0: float
var _base_request: String = "http://5.189.191.115:8123/"
var _results


func get_images_of(gattung_name: String) -> Array[ImageTexture]:
	t0 = Time.get_ticks_msec()
	_results = []
	_disconnect_requester()
	
	var request: String = _base_request + "get_images_of/%s/" % gattung_name
	_requester.request_completed.connect(_on_get_images_request_request_completed)
	_requester.call_deferred("request", request)
	_logger.debug("Requesting %s" % request)
	await _Request_Completed
	
	return _results as Array[ImageTexture]
	

func _on_get_images_request_request_completed(_result, response_code, _headers, body) -> void:
	var images: Array[ImageTexture] = []
	if response_code == 200:
		var json_arr = JSON.parse_string(body.get_string_from_utf8())
		if json_arr:
			images = _get_images_from_json(json_arr)
	else:
		_logger.warning("Failed HTTP Request, error code: %s" % response_code)
		
	_results = images
	_Request_Completed.emit()


func _get_images_from_json(json_arr: Array) -> Array[ImageTexture]:
	var images: Array[ImageTexture] = []
	for base64_str in json_arr:
		var image_bytes = Marshalls.base64_to_raw(base64_str)
		var image = Image.new()
		var err = image.load_jpg_from_buffer(image_bytes)  # Or use load_png_from_buffer()
		if err == OK:
			images.append(ImageTexture.create_from_image(image))
		else:
			_logger.info("Could not decode image from base64-string.")
	_logger.info("Successfully loaded %s image texture(s), took %s seconds" % [len(json_arr), str((Time.get_ticks_msec() - t0)/1000)])
	return images


func _disconnect_requester() -> void:
	for conn in _requester.request_completed.get_connections():
		_requester.request_completed.disconnect(conn["callable"])
