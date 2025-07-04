shader_type canvas_item;

uniform float current_time;
uniform float ring_width:hint_range(0.005, 0.02);

bool is_in_scan_line(vec2 pos) {
	float angle = atan(pos.y - 0.5, pos.x - 0.5);
	
	float actual_time = current_time;
	while (actual_time > PI) {
		actual_time -= 2.0 * PI;
	}
	
	return abs(angle - actual_time) < 0.02;
}

bool is_in_border_ring(vec2 pos) {
	float dist = distance(pos, vec2(0.5));

	return dist > 0.5 - ring_width && dist < 0.5;
}

bool is_outside(vec2 pos) {
	float dist = distance(pos, vec2(0.5));

	return dist > 0.5;
}

void fragment() {
	if (is_in_scan_line(UV)) {
		COLOR.rgb = vec3(0.7);
		COLOR.a = 0.8;
	}

	if (is_in_border_ring(UV)) {
		COLOR.rgb = vec3(0.1);
		COLOR.a = 0.8;
	}

	if (is_outside(UV)) {
		COLOR = vec4(0.0);
	}
}
