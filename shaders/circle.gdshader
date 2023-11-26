shader_type canvas_item;


uniform float radius: hint_range(0.0, 1.0) = 1.0;
uniform float fill: hint_range(0.0, 1.0) = 1.0;
uniform float radial_fill: hint_range(0.0, 1.0) = 1.0;


void fragment() {
	float half_radius = radius * 0.5;
	float quarter_fill = fill * 0.25;
	
	vec2 uv = UV - vec2(0.5, 0.5);
	float len = length(uv);
	float half_length = len * 0.5;
	
	// Circle and Ring
	float ring_feather = fwidth(len);
	float ring_alpha = smoothstep(ring_feather, 0.0, abs(len - half_radius + quarter_fill + ring_feather) - quarter_fill);
	
	// Radial Cutout
	float theta = atan(uv.x, -uv.y);
	float angle = theta / TAU + 0.5;
	float radial_feather = fwidth(angle) * 1.5;
	float radial_alpha = smoothstep(radial_fill + radial_feather, radial_fill, angle);
	
	float fill_alpha = min(ring_alpha, radial_alpha);
	COLOR.a *= fill_alpha;
}
