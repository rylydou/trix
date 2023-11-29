shader_type canvas_item;

uniform float n = .7;


float norm(float e, vec2 v) {
	v = abs(v);
	if (v.y > v.x) { v = v.xy; }
	if (v.y == 0.0) { return v.x; }
	v = vec2(e * log(v));
	float logSumExp = v.x + log(1.0 + exp(v.y - v.x));
	
	return exp(logSumExp / e);
}


float circle(vec2 uv, vec2 pos, float rad, float e) {
	float d = norm(e, pos - uv) - rad;
	return smoothstep( 0., 1.5, d/fwidth(d) );
}


void fragment() {
	COLOR.a = 1.0 - circle(UV, vec2(.5), .5, n);
}
