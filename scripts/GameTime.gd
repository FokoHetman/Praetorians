@tool
class_name GameTime extends Node2D

var year
var day
var hour
var speed = 1
var paused = true



func format() -> String:
	var era = "A.C"
	if year<0:
		era = "B.C"
	return str(get_day(day)) + "." + str(get_month(day)) + "." + str(abs(year)) + " " + era


func is_leap(year: int) -> bool:
	return (year % 4 == 0 && year % 100 != 0) || (year%400==0)

var month_lens = [31,"leap", 31,30,31,30,31,31,30,31,30,31]
func get_month(day: int) -> int:
	var nday = day
	var month = 1
	for i in month_lens:
		var neg = i
		if typeof(i) == TYPE_STRING:
			neg = int(is_leap(year))*29 + int(!is_leap(year))*28
		if nday<=neg:
			break
		nday-=neg
		month += 1
	return month

func get_day(day: int) -> int:
	var nday = day
	for i in month_lens:
		if typeof(i) == TYPE_STRING:
			i = int(is_leap(year))*29 + int(!is_leap(year))*28
		if nday <= i:
			break
		nday-=i
	return nday


func _init(g_year,g_day,g_hour):
	year = g_year
	day = g_day
	hour = g_hour

func _ready():
	var tick_count = 0
	while true:
		await wait(1.0/speed)
		tick_count += 1
		# print('tick ', tick_count)
		if !paused:
			hour+=speed
			if hour>24:
				day+=1
				hour = 1
			if day>365:
				year+=1
				day = 1
			hour+=speed

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
