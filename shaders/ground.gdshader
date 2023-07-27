shader_type spatial;

uniform sampler2D Texture;

void fragment() {
	ALBEDO = texture(Texture, UV).rgb;
	// Place fragment code here.
}
