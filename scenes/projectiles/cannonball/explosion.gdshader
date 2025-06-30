shader_type canvas_item;

uniform vec4 start_colour:source_color;
uniform vec4 end_colour:source_color;
uniform float time_period:hint_range(0.0, 1.0);
uniform float current_time:hint_range(0.0, 1.0);

void fragment() {
	vec2 centre = vec2(0.5, 0.5);
	float dist_from_centre = distance(centre, UV);

	float ring_near_side = (current_time / time_period) - 0.5;
	float ring_far_side = min(0.5, current_time / time_period);

	if (dist_from_centre >= ring_near_side && dist_from_centre <= ring_far_side) {
		float mix_step = 1.0 - cos(PI * dist_from_centre);
		float alpha = cos((7.0 / 8.0) * PI * dist_from_centre);

		COLOR.rgb = mix(start_colour, end_colour, mix_step).rgb;
		COLOR.a = alpha;
	}
	else {
		COLOR.a = 0.0;
	}
}
