shader_type canvas_item;

uniform bool show_scan_line;
uniform float ring_width:hint_range(0.005, 0.02);

uniform float current_time:hint_range(0.0, 1.0);

bool is_in_scan_line(vec2 pos) {
	float angle = atan(pos.y - 0.5, pos.x - 0.5);

	float actual_time = current_time;
	if (actual_time > 0.5) {
		actual_time -= 1.0;
	}

	return abs(angle - 2.0 * PI * actual_time) < 0.02;
}

float get_similarity_to_scan_line(vec2 pos) {
	float angle = atan(pos.y - 0.5, pos.x - 0.5);
	angle += PI;
	
	//if (current_time > 0.5) {
		//angle -= PI;
	//}
	
	//if (angle < 0.0) {
		//angle += 2.0 * PI;
	//}

	float actual_time = current_time;
	float scan_angle = 2.0 * PI * actual_time;
	//scan_angle -= PI;
	
	//if (scan_angle > PI) {
		//scan_angle -= 2.0 * PI;
	//}
	
	//if (angle > 0.0 && scan_angle < 0.0) {
		//angle += 2.0 * PI;
	//}

	float dist = scan_angle - angle;

	if (dist < 0.0) {
		return 0.0;
	}

	return 1.0 - dist;
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
	if (show_scan_line) {
		COLOR.rgb = vec3(0.0, 0.8, 0.0);
		COLOR.a = 0.8 * get_similarity_to_scan_line(UV);
	}

	if (is_in_border_ring(UV)) {
		COLOR.rgb = vec3(0.1);
		COLOR.a = 0.8;
	}

	if (is_outside(UV)) {
		COLOR = vec4(0.0);
	}
}
