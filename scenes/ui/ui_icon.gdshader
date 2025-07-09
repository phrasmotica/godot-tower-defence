shader_type canvas_item;

uniform float alpha_threshold:hint_range(0.0, 1.0);
uniform float alpha_mix:hint_range(0.0, 1.0);
uniform vec4 replacement_colour:source_color = vec4(1.0);

void fragment() {
	// 1.0 if alpha is above threshold, else 0.0
	float alpha_factor = step(alpha_threshold, COLOR.a);
	vec3 rgb = mix(COLOR.rgb, replacement_colour.rgb, alpha_factor);

	// lerp between COLOR.a and 1.0
	float alpha = alpha_factor * mix(COLOR.a, 1.0, alpha_mix);

	COLOR = vec4(rgb, alpha);
}
