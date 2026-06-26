shader_type canvas_item;

varying vec4 vertex_color;

void vertex() {
	vertex_color = COLOR;
}

void fragment() {
	COLOR = vertex_color;
}