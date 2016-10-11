from parse_rest.connection import register, ParseBatcher
# Alias the Object type to make clear is not a normal python Object
from parse_rest.datatypes import Object as ParseObject
from parse_rest.user import User
from wiringx86 import GPIOEdison as GPIO
import sys


gpio = GPIO(debug=False)

u_id = "A2837C04-4AE1-441A-95D5-C25E6D9D1D10"

def reg():
	APPLICATION_ID = "TBhSWVtf7LUzCUxUlhF5wFfLKdquF4jEJjK1cVqQ"
	REST_API_KEY = "j3QxkFjL9zzOiSMrUqlQYFh5VZRKSrvWh3A7Ob3a"
	register(APPLICATION_ID, REST_API_KEY)


class UserTable(ParseObject):
	pass

reg()

gpio.pinMode(4, gpio.OUTPUT)
gpio.pinMode(5, gpio.OUTPUT)
gpio.pinMode(6, gpio.OUTPUT)
gpio.pinMode(7, gpio.OUTPUT)

def handler_left():
	gpio.digitalWrite(4, gpio.LOW)
	gpio.digitalWrite(5, gpio.LOW)
	gpio.digitalWrite(6, gpio.HIGH)
	gpio.digitalWrite(7, gpio.LOW)


def handler_straight():
	gpio.digitalWrite(4, gpio.HIGH)
	gpio.digitalWrite(5, gpio.LOW)
	gpio.digitalWrite(6, gpio.HIGH)
	gpio.digitalWrite(7, gpio.LOW)

def handler_right():
	
	gpio.digitalWrite(4, gpio.HIGH)
	gpio.digitalWrite(5, gpio.LOW)
	gpio.digitalWrite(6, gpio.LOW)
	gpio.digitalWrite(7, gpio.LOW)

def handler_start():
	gpio.digitalWrite(4, gpio.HIGH)
	gpio.digitalWrite(5, gpio.LOW)
	gpio.digitalWrite(6, gpio.HIGH)
	gpio.digitalWrite(7, gpio.LOW)

def handler_stop():
	gpio.digitalWrite(4, gpio.LOW)
	gpio.digitalWrite(5, gpio.LOW)
	gpio.digitalWrite(6, gpio.LOW)
	gpio.digitalWrite(7, gpio.LOW)


while 1:

	query_result = UserTable.Query.filter(user_id = u_id,vehicle_id = "1")
	vehicle_control_object = query_result[0]
	rep = vehicle_control_object.control_field
	print "the reply is ",rep
	
	if rep == "LEFT":
		handler_left()
	elif rep == "RIGHT":
		handler_right()
	elif rep == "STRAIGHT":
		handler_straight()
	elif rep == "START":
		handler_start()
	elif rep == "STOP":
		handler_stop()


sys.exit()
              # Close the connection