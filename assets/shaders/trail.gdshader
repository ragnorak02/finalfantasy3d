shader_type spatial;
render_mode blend_add, depth_draw_never, cull_disabled, unshaded;

uniform vec4 trail_color : source_color = vec4(0.5, 0.7, 1.0, 0.6);
uniform float fade_speed : hint_range(0.1, 5.0) = 2.0;

varying float vertex_alpha;

void vertex() {
	vertex_alpha = UV.y;
}

void fragment() {
	float alpha = (1.0 - vertex_alpha) * trail_color.a;
	ALBEDO = trail_color.rgb;
	ALPHA = alpha;
}
