shader_type canvas_item;

uniform float show: hint_range(0.0, 1.0, 0.01) = 1.;
uniform float distorsion: hint_range(0.0, 0.05, 0.001) = 0.;
uniform vec2 resolution = vec2(320,240);
uniform vec2 offset = vec2(.5, .5);

const float frequence = 1.;
const float dist = 1.;
const vec3 spread_color = vec3(.4, .1, .5);
const vec3 color1 = vec3(.85, .75, 1);
const vec3 color2 = vec3(.35, .0, .35);

float spiral(vec2 uv, float t) {
    float angle = atan(uv.y, uv.x);
    float l = length(uv);
    float offs = (log(l)+(angle/(2.*PI))*dist);
    return mod(offs + t, dist);
}

vec2 wave(vec2 uv, float d) {
    float l = length(uv);
    return vec2(
        cos((uv.y*50. + TIME*1.) * 2.*PI) * log(l + 1.) * d,
        sin((uv.x*50. + TIME*1.) * 2.*PI) * log(l + 1.) * d
    );
}

void fragment() {
	vec2 uv = UV - offset;
	uv = floor(uv * resolution) / resolution;
	float l = length(uv);
    float render = spiral(uv+vec2(1,0)*wave(uv,distorsion), TIME * frequence);
	COLOR = vec4(0, 0, 0, l * show * 2.);
	COLOR += (render < spread_color.r) ? vec4(color1.r,0,0,0) : vec4(color2.r,0,0,0);
	COLOR += (render < spread_color.g) ? vec4(0,color1.g,0,0) : vec4(0,color2.g,0,0);
	COLOR += (render < spread_color.b) ? vec4(0,0,color1.b,0) : vec4(0,0,color2.b,0);
}
