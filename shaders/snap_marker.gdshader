shader_type spatial;
render_mode unshaded;

uniform float period = 2.;

void fragment() {
	float outline = float(
		length(UV-.5) - .5 < 0. &&
		length(UV-.5) - .5 > -.01
	);
	
	float outline2 = float(
		mod(length(UV-.5), .5) < (mod(TIME*.5/period, .5)) + .01 &&
		mod(length(UV-.5), .5) > (mod(TIME*.5/period, .5)) - .01
	) * clamp(1. - length(UV-.5)/.5, 0., 1.) * .5;
	
	ALBEDO = vec3(.35,.35,.35);
	ALPHA =
		outline + 
		outline2;
}
