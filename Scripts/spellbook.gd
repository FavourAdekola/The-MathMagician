extends Panel

@onready var equation = $Control/Equation
@onready var player = get_parent().get_parent()
@onready var rng = RandomNumberGenerator.new()

enum FILL {NONE, FIRST_NUMBER, SECOND_NUMBER}
enum SYMBOL {NONE, PLUS, MINUS, MULTIPLY, DIVIDE}

var state = FILL.NONE

var first_number = []

var second_number = []

var symbol = SYMBOL.NONE



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Operators/SubtractionSign.visible = GlobalVar.subtraction
	$Operators/DivisionSign.visible = GlobalVar.division
	$Operators/MultiplicationSign.visible = GlobalVar.multiplication
	
	if GlobalVar.room == "final room":
		$Label.show()
		$Label.text = str(int(player.parent.get_node("Timer").time_left))


func is_allow_to_write_symbol():
	return (symbol == SYMBOL.NONE and state == FILL.FIRST_NUMBER)
	
func append_to_number(number):
	second_number.append(number)

func prep_operations():
	
	if GlobalVar.room == "final room":
		state = FILL.SECOND_NUMBER
		if symbol == SYMBOL.MINUS:
			while player.starting_number < player.needed_number:
				if player.needed_number > 0:
					player.starting_number = rng.randi_range(1,player.needed_number)
				else:
					player.starting_number = rng.randi_range(player.needed_number, 1)
		if symbol == SYMBOL.PLUS:
			while player.starting_number > player.needed_number:
				if player.needed_number > 0:
					player.starting_number = rng.randi_range(1,player.needed_number)
				else:
					player.starting_number = rng.randi_range(player.needed_number, 1)
		if symbol == SYMBOL.MULTIPLY:
			if player.starting_number == 0:
				player.starting_number = 1
			while is_prime(player.needed_number) or player.needed_number % player.starting_number != 0:
				player.needed_number = rng.randi_range(1,9999)
				player.parent.boss_value = player.needed_number
				var divisor = rng.randi_range(2,999)
				print(divisor)
				if divisor != 0:
					print(player.needed_number)
					player.starting_number = player.needed_number/divisor
		if symbol == SYMBOL.DIVIDE:
			player.starting_number = player.needed_number*rng.randi_range(1,99)
					
	else:
		state = FILL.FIRST_NUMBER
	for i in str(player.starting_number):
		first_number.append(int(i))
		equation.text += i
	if GlobalVar.room == "final room":
		print(symbol)
		match symbol:
			SYMBOL.PLUS:
				equation.text += "+"
			SYMBOL.MINUS:
				equation.text += "-"
			SYMBOL.DIVIDE:
				equation.text += "÷"
			SYMBOL.MULTIPLY:
				equation.text += "x"
		



func is_prime(number):
	if number < 2:
		return false
	if number == 2:
		return true
	if number % 2 == 0:
		return false
	var i = 3
	for divisor in range(2, int(sqrt(number)) + 1):
		if number % divisor == 0:
			return false
	return true
		
####################################
#          NUMBER BUTTONS          #
####################################

func _on_number_zero_button_down():
	if state == FILL.SECOND_NUMBER:
		equation.text += "0"
		append_to_number(0)

func _on_number_one_button_down():
	if state == FILL.SECOND_NUMBER:
		equation.text += "1"
		append_to_number(1)

func _on_number_two_button_down():
	if state == FILL.SECOND_NUMBER:
		equation.text += "2"
		append_to_number(2)

func _on_number_three_button_down():
	if state == FILL.SECOND_NUMBER:
		equation.text += "3"
		append_to_number(3)

func _on_number_four_button_down():
	if state == FILL.SECOND_NUMBER:
		equation.text += "4"
		append_to_number(4)

func _on_number_five_button_down():
	if state == FILL.SECOND_NUMBER:
		equation.text += "5"
		append_to_number(5)
	

func _on_number_six_button_down():
	if state == FILL.SECOND_NUMBER:
		equation.text += "6"
		append_to_number(6)

func _on_number_seven_button_down():
	if state == FILL.SECOND_NUMBER:
		equation.text += "7"
		append_to_number(7)

func _on_number_eight_button_down():
	if state == FILL.SECOND_NUMBER:
		equation.text += "8"
		append_to_number(8)

func _on_number_nine_button_down():
	if state == FILL.SECOND_NUMBER:
		equation.text += "9"
		append_to_number(9)

func _on_clear_button_down():
	second_number = []
	first_number = []
	equation.text = ""
	if GlobalVar.room != "final room":
		state = FILL.FIRST_NUMBER
		symbol = SYMBOL.NONE
	else:
		state = FILL.SECOND_NUMBER
		symbol =  player.parent.temp_save
		
	prep_operations()


#######################################
#          OPERATION BUTTONS          #
#######################################



func _on_addition_sign_button_down():
	if is_allow_to_write_symbol():
		equation.text += "+"
		symbol = SYMBOL.PLUS
		state = FILL.SECOND_NUMBER


func _on_subtraction_sign_button_down():
	if is_allow_to_write_symbol():
		equation.text += "-"
		symbol = SYMBOL.MINUS
		state = FILL.SECOND_NUMBER


func _on_division_sign_button_down():
	if is_allow_to_write_symbol():
		equation.text += "÷"
		symbol = SYMBOL.DIVIDE
		state = FILL.SECOND_NUMBER


func _on_multiplication_sign_button_down():
	if is_allow_to_write_symbol():
		equation.text += "x"
		symbol = SYMBOL.MULTIPLY
		state = FILL.SECOND_NUMBER
	


func _on_enter_button_down():
	if state == FILL.SECOND_NUMBER:
		var local_first_number = convert_array_to_int(first_number)
		var local_second_number = convert_array_to_int(second_number)
		
		var result = get_result(local_first_number, local_second_number)
		
		equation.text = str(result)
		player.calc_value = result
		player.check_value()
		set_state_to_first_number()


func _on_number_down():
	if state == FILL.NONE:
		state = FILL.FIRST_NUMBER
		
func convert_array_to_int(array_value):
	var string_value = ""
	for a in array_value:
		string_value += str(a)
		
	var int_value = 0
	if is_minus_value(array_value):
		int_value = -int(string_value)
	else:
		int_value = int(string_value)
	return int_value
	
func is_minus_value(array_value):
	return array_value[0] == 0

func get_result(local_first_number, local_second_number):
	match symbol:
		SYMBOL.PLUS:
			return local_first_number + local_second_number
		SYMBOL.MINUS:
			return local_first_number - local_second_number
		SYMBOL.MULTIPLY:
			return local_first_number * local_second_number
		SYMBOL.DIVIDE:
			if local_second_number != 0:
				return local_first_number / local_second_number
	return 0

func set_state_to_first_number():
	state = FILL.FIRST_NUMBER
	symbol = SYMBOL.NONE
	second_number = []

func set_result_to_first(result):
	if result == 0:
		_on_clear_button_down()
	first_number = []
	second_number = []
	for fn in str(result):
		first_number.append(int(fn))


func _on_key_button_down():
	player.activate_item("key")


func _on_close_button_down():
	player.book_closed()
