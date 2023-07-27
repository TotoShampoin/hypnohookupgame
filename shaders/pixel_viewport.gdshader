shader_type canvas_item;

uniform sampler2D screen: hint_screen_texture;

void fragment() {
	vec2 uv = UV;
	COLOR = texture(TEXTURE, uv);
}
