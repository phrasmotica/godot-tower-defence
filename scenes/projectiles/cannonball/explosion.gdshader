shader_type canvas_item;

uniform vec4 start_colour:source_color;
uniform vec4 end_colour:source_color;
uniform float time_period:hint_range(0.0, 1.0);
uniform float current_time:hint_range(0.0, 1.0);

void fragment() {
	vec2 centre = vec2(0.5, 0.5);
	float dist_from_centre = distance(centre, UV);

	float ring_near_side = (current_time / time_period) - 0.5;

	//float ring_width = 0.1 * (time_period - current_time) / time_period;
	float ring_far_side = min(0.5, current_time / time_period);

	if (dist_from_centre >= ring_near_side && dist_from_centre <= ring_far_side) {
		COLOR.rgba = mix(start_colour, end_colour, 2.0 * dist_from_centre);
	}
	else {
		COLOR.a = 0.0;
	}
}
