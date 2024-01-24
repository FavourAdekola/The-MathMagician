extends Panel

@onready var equation = $Control/Equation

var total = 0
var input = ""
var result = 0
var item = " "

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	equation.text = input
	if result == 0:
		print(input)
	else:
		print(result)

####################################
#          NUMBER BUTTONS          #
####################################

func _on_number_zero_button_down():
	
	input += "0"

func _on_number_one_button_down():
	input += "1"

func _on_number_two_button_down():
	input += "2"

func _on_number_three_button_down():
	input += "3"

func _on_number_four_button_down():
	input += "4"

func _on_number_five_button_down():
	input += "5"

func _on_number_six_button_down():
	input += "6"

func _on_number_seven_button_down():
	input += "7"

func _on_number_eight_button_down():
	input += "8"

func _on_number_nine_button_down():
	input += "9"

func _on_clear_button_down():
	input = ""


#######################################
#          OPERATION BUTTONS          #
#######################################



func _on_addition_sign_button_down():
	input += "+"


func _on_subtraction_sign_button_down():
	input += "-"


func _on_division_sign_button_down():
	input += "÷"


func _on_multiplication_sign_button_down():
	input += "x"


func _on_enter_button_down():
	if input.contains:
		result = activate_item(item)
	elif input:
		pass
		
func activate_item(item_name):
	print("activated")
