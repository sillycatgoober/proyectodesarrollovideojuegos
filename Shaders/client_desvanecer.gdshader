shader_type canvas_item;
uniform float progress : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec4 negro = vec4(0.0, 0.0, 0.0, tex.a);
    COLOR = mix(negro, tex, progress);
    COLOR.a = tex.a * progress;
}