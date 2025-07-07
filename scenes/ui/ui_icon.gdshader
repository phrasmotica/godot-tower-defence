shader_type canvas_item;

uniform float alpha_threshold:hint_range(0.0, 1.0);
uniform vec4 replacement_colour:source_color = vec4(1.0);

void fragment() {
	// 1.0 if alpha is above threshold, else 0.0
	float alpha_factor = step(alpha_threshold, COLOR.a);
	
	COLOR = vec4(
		mix(COLOR.rgb, replacement_colour.rgb, alpha_factor),
		alpha_factor
	);
}
