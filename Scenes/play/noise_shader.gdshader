shader_type canvas_item;

uniform float color_base = 0.05;
uniform float color_power = 8.0;
uniform float color_strength = 1.0;
uniform float color_radius = 1.414213;

varying vec4 vertex_color;

void vertex() {
	vertex_color = COLOR;
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec3 col = (tex * vertex_color).rgb;
	vec2 uv = 2.0 * (UV - 0.5);
	float d = min(color_radius, distance(vec2(0), uv));
	COLOR = vec4(col, clamp(color_base + pow(d, color_power) * color_strength, 0.0, 1.0));
}