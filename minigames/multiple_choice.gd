extends Control
class_name MultipleChoiceGame


@onready var requester: HTTPRequest = $HTTPRequest
var t0: float

func _ready() -> void:
	var request: String = "http://5.189.191.115:8123/get_images_of/acinos/"
	t0 = Time.get_ticks_msec()
	var err: Error = requester.request(request)
	if err != OK:
		print("Error with request: %s, errorcode: %s" %[request, err])


func _on_http_request_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var json_arr = JSON.parse_string(body.get_string_from_utf8())
		if json_arr:
			var base64_str = json_arr[0]
			var image_bytes = Marshalls.base64_to_raw(base64_str)
			
			var image = Image.new()
			var err = image.load_jpg_from_buffer(image_bytes)  # Or use load_png_from_buffer()
			if err == OK:
				var texture = ImageTexture.create_from_image(image)
				$Sprite2D.texture = texture
				print("Successfully loaded image texture, took %s seconds" % str((Time.get_ticks_msec() - t0)/1000))
