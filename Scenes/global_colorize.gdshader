shader_type canvas_item;

uniform vec4 target_color : source_color;
uniform float target_mix;

varying vec4 vertex_color; 

void vertex() {
	vertex_color = COLOR;
}

void fragment() {
    vec4 src_color = COLOR * vertex_color;
    COLOR = vec4((1.0 - target_mix) * src_color.rgb + target_mix * target_color.rgb, src_color.a);
}