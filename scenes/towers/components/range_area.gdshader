//	Radar shader v2 by Brian Smith (steampunkdemon.itch.io)
//	MIT Licence

shader_type canvas_item;

group_uniforms TimeParameters;

uniform float current_time:hint_range(0.0, 1.0);

group_uniforms VisualParameters;

uniform bool show_trail;
uniform vec4 beam_color : source_color = vec4(0.5, 1.0, 0.5, 1.0);
uniform vec4 trail_color : source_color = vec4(0.0, 0.5, 0.0, 1.0);
uniform float beam_width : hint_range(0.0, 0.05) = 0.003;
uniform float trail_width : hint_range(0.0, 1.0) = 0.25;

float greater_than(float x, float y) {
	return max(sign(x - y), 0.0);
}

void fragment() {
	// these are our coordinates between (-1, -1) and (1, 1)
	vec2 uv = UV * 2.0 - 1.0;

	if (show_trail) {
		// this is in the range [0, 1]
		float angle = (atan(uv.y, uv.x) + PI) / (2.0 * PI);

		// this is our progress through the animation
		float current_beam_angle = current_time;

		// wrap around to "before" the beam angle if we're ahead of it
		angle = angle - 1.0 * greater_than(angle, current_beam_angle);

		// render the trail
		float trail_mix_amount = max(0.0, (1.0 - (current_beam_angle - angle) / trail_width));
		COLOR.rgb = mix(COLOR.rgb, trail_color.rgb, trail_color.a * trail_mix_amount);

		// render the beam
		float beam_mix_amount = greater_than(angle, current_beam_angle - beam_width);
		COLOR.rgb = mix(COLOR.rgb, beam_color.rgb, beam_color.a * beam_mix_amount);
	}

	// don't show anything beyond the circle
	COLOR.a *= greater_than(1.0, length(uv));
}
