shader_type canvas_item;

uniform float greyness = 0.5;

const float RED_LUMINANCE = 0.2126;
const float GREEN_LUMINANCE = 0.7152;
const float BLUE_LUMINANCE = 0.0722;

varying vec4 vertex_color; 

void vertex() {
	vertex_color = COLOR;
}

void fragment() {
    vec4 col = COLOR * vertex_color;

	float luminance = (col.r*RED_LUMINANCE + col.g*GREEN_LUMINANCE + col.b*BLUE_LUMINANCE);
	col = vec4(vec3(luminance), col.a);
	
    COLOR = (1.0 - greyness) * COLOR * vertex_color + greyness * col;
}