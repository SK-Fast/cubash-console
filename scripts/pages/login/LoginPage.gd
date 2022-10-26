extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var username_input: LineEdit = get_node("LoginPanel/FormContainer/List/Username/Input")
onready var password_input: LineEdit = get_node("LoginPanel/FormContainer/List/Password/Input")
onready var form_container: Control = get_node("LoginPanel/FormContainer")

var login_step = 0
var login_step_str = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	ButtonsSystem.add_button("L1", "Reveal Password")
	ButtonsSystem.add_button("AButton", "Select")
	
	$LoginRequest.connect("request_completed", self, "_on_request_completed")

func _on_login_requested():
	login_step = 0
	
	$LoginRequest.request(
		"https://api.cubash.com/authorization/session",
		[
			"Content-Type: application/json"
		],
		true,
		HTTPClient.METHOD_GET
	)
	
	login_step_str = "First Session Fetch"
	
	set_form_inactive(form_container)

func set_form_active(form: Control):
	form.modulate = Color(1,1,1,1)
	form.mouse_filter = Control.MOUSE_FILTER_STOP

func set_form_inactive(form: Control):
	form.modulate = Color(1,1,1,0.5)
	form.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var response_data = json.result
	
	#print(login_step_str, ":  ", result)
	print(login_step_str, ":  ", response_code)
	print(login_step_str, ":  ", body.get_string_from_utf8())
	#print(login_step_str, ":  ", headers)
	
	#print(headers)
		
	if response_code != 201 and login_step == 1:
		set_form_active(form_container)
		
		if response_data['errors']:
			print("Error detected")
			if response_data.errors[0].param == "password":
				print("Password")
				NotifyService.notify("Incorrect Password", "Please check and attempt again")
			elif response_data.errors[0].param == "username":
				print("Username")
				NotifyService.notify("Username missing", response_data.errors[0].msg)
			else:
				print("Other")
				NotifyService.notify("Unable to login you in", response_data.errors[0].msg)
	
	if login_step == 0:
		print("Loging in")
		print(JSON.print(headers))
		
		var header = HttpService.parse_header(headers)
		
		GlobalVars.csrf = response_data.csrf
		GlobalVars.cookie = header["set-cookie"]
		
		print(header)
		
		var login_data = JSON.print({
			"username": username_input.text,
			"password": password_input.text
		})
		
		print(login_data)
		
		print(GlobalVars.csrf)
		
		print("cookie: " + GlobalVars.cookie)
	
		login_step_str = "Login"
		
		$LoginRequest.request(
			"https://api.cubash.com/authentication/login",
			[
				"Content-Type: application/json; charset=utf-8",
				"user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36",
				"cookie: " + GlobalVars.cookie,
				"x-csrf-token: " + GlobalVars.csrf
			],
			true,
			HTTPClient.METHOD_POST,
			login_data
		)
		
		login_step = login_step + 1
	
	if login_step == 1:
		print("Getting Session data")
		
		login_step_str = "Re session"
		
		$LoginRequest.request(
			"https://api.cubash.com/authorization/session",
			[
				"Content-Type: application/json",
				"Cookie: _csrf=" + GlobalVars.csrf,
				"x-csrf-token: " + GlobalVars.csrf
			],
			true,
			HTTPClient.METHOD_GET
		)
		
		login_step = login_step + 1
	
	if login_step == 2:
		print("Checking for Totp...")
		
		login_step_str = "TOTP Check"
		
		if response_data['meta']['restriction'] == "totp":
			return
		
		login_step = login_step + 1
	
	
