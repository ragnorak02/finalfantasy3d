shader_type canvas_item;

uniform float desaturation : hint_range(0.0, 1.0) = 0.7;
uniform vec4 tint_color : source_color = vec4(0.3, 0.3, 0.5, 0.3);
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.4;

void fragment() {
	vec4 screen_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	float gray = dot(screen_color.rgb, vec3(0.299, 0.587, 0.114));
	vec3 desaturated = mix(screen_color.rgb, vec3(gray), desaturation);
	vec3 tinted = mix(desaturated, tint_color.rgb, tint_color.a);

	float dist = distance(SCREEN_UV, vec2(0.5));
	float vignette = smoothstep(0.3, 0.8, dist) * vignette_strength;
	tinted = mix(tinted, tinted * 0.5, vignette);

	COLOR = vec4(tinted, 1.0);
}
