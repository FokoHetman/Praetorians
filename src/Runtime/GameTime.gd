@tool
class_name GameTime extends Node


var VNIX_ROMANVM = 0 # "Unix" time. this one measures **hours** since start of the game
var year
var day
var hour
var speed = 1
var paused = true

signal hourtick
signal daytick
signal redraw
signal speed_redraw
signal state_redraw

func inc():
	if speed >= 5:
		return
	speed += 1

	speed_redraw.emit(speed)
func dec():
	if speed <= 1:
		return
	speed -= 1

	speed_redraw.emit(speed)

func set_playing(b):
	self.paused = b
	state_redraw.emit(paused)
func toggle():
	self.paused = not paused
	state_redraw.emit(paused)

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


var ticker = 0.0
const SPEEDS = [4, 24, 336, 1440, 4320]
func _process(d):
	if !paused:
		ticker += d * SPEEDS[speed-1]
		while ticker >= 1.0:
			ticker -= 1.0
			hour_ticker()

func hour_ticker():
	VNIX_ROMANVM += 1
	hour+=1
	hourtick.emit(VNIX_ROMANVM)
	if hour>24:
		daytick.emit(VNIX_ROMANVM)
		day+=1
		hour = 0
	if (is_leap(year) and day>366) or (not is_leap(year) and day>365):
		year+=1
		day = 1
		if year==0:
			year=1
	redraw.emit(format())


func wait(seconds: float) -> void:
	if get_tree() != null:
		await get_tree().create_timer(seconds).timeout
