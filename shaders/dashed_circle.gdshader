shader_type canvas_item;


uniform float radius: hint_range(0.0, 1.0) = 1.0;
uniform float fill: hint_range(0.0, 1.0) = 1.0;
uniform float dash_count = 8.0;


void fragment() {
	float half_radius = radius * 0.5;
	float quarter_fill = fill * 0.25;
	float dash = 1. / dash_count * 0.5;
	
	vec2 uv = UV - vec2(0.5, 0.5);
	float len = length(uv);
	float half_length = len * 0.5;
	
	// Circle and Ring
	float ring_feather = fwidth(len);
	float ring_alpha = smoothstep(ring_feather, 0.0, abs(len - half_radius + quarter_fill + ring_feather) - quarter_fill);
	
	// Radial Cutout
	float theta = atan(uv.x, -uv.y);
	float angle = theta / TAU + 0.5;
	float dash_feather = fwidth(angle);
	float dash_alpha = smoothstep(dash + dash_feather, dash, mod(angle, dash * 2.0));
	
	float fill_alpha = min(ring_alpha, dash_alpha);
	COLOR.a *= fill_alpha;
}
