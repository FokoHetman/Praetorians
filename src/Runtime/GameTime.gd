@tool
class_name GameTime extends Node2D

var year
var day
var hour
var speed = 1
var paused = true

var redraw_hooks: Array[Callable] = []
var speed_redraw_hooks: Array[Callable] = []
var state_redraw_hooks: Array[Callable] = []

func inc():
	if speed >= 5:
		return
	speed += 1

	for i in speed_redraw_hooks:
		i.call(speed)

func dec():
	if speed <= 1:
		return
	speed -= 1

	for i in speed_redraw_hooks:
		i.call(speed)

func set_playing(b):
	self.paused = b
	for i in state_redraw_hooks:
		i.call(paused)
func toggle():
	self.paused = not paused
	for i in state_redraw_hooks:
		i.call(paused)

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
	
var default_multiplier = 5

func _ready():
	var tick_count = 0
	while true:
		await wait(1.0/(default_multiplier**(speed**speed)))
		tick_count += 1
		# print('tick ', tick_count)
		if !paused:
			hour+=1
			if hour>24:
				day+=1
				hour = 0
			if (is_leap(year) and day>366) or (not is_leap(year) and day>365):
				year+=1
				day = 1
			hour+=speed
			for i in redraw_hooks:
				i.call(format())
func wait(seconds: float) -> void:
	if get_tree() != null:
		await get_tree().create_timer(seconds).timeout
