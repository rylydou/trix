shader_type canvas_item;

uniform float from = 1.0;
uniform float to = 0.0;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;


void fragment() {
	COLOR.rgb = mix(vec3(from), vec3(to), texture(SCREEN_TEXTURE, SCREEN_UV).rgb);
}
