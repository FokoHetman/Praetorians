@tool
extends Path2D
class_name PathText

@export var text: String:
	set(value):
		if text != value:
			text = value
			queue_redraw()

@export var label_settings: LabelSettings:
	set(value):
		if is_instance_valid(label_settings) and label_settings.changed.is_connected(queue_redraw):
			label_settings.changed.disconnect(queue_redraw)

		label_settings = value

		if is_instance_valid(label_settings):
			label_settings.changed.connect(queue_redraw)


var _line = TextLine.new()


func _draw() -> void:
	# Get the font, font size and color from the ThemeDB
	var font = ThemeDB.fallback_font
	var font_size = ThemeDB.fallback_font_size
	var font_color = Color.WHITE

	# If the label_settings is valid, then use the values from it
	if is_instance_valid(label_settings):
		font = label_settings.font
		font_size = label_settings.font_size
		font_color = label_settings.font_color

	# Clear the line and add the new string
	_line.clear()
	_line.add_string(text, font, font_size)
	# Get the primary TextServer
	var ts = TextServerManager.get_primary_interface()
	# And get the glyph information from the line
	var glyphs = ts.shaped_text_get_glyphs(_line.get_rid())

	var offset = 0.0
	for glyph_data in glyphs:
		# Sample the curve with rotation at the offset
		var trans = curve.sample_baked_with_rotation(offset)
		# set the draw matrix to that transform
		draw_set_transform_matrix(trans)
		# draw the glyph
		ts.font_draw_glyph(glyph_data["font_rid"], get_canvas_item(), font_size, Vector2.ZERO, glyph_data["index"], font_color)
		# add the advance to the offset
		offset += glyph_data.get("advance", 0.0)
