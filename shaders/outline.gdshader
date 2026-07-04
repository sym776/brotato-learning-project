shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0, 1.0) = 5.0;
uniform float glow_intensity : hint_range(0.0, 10.0, 0.1) = 4.0;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);

	if (tex_color.a > 0.0) {
		COLOR = tex_color;
	} else {
		vec2 pixel_size = 1.0 / vec2(textureSize(TEXTURE, 0));
		bool is_outline = false;

		for (int x = -10; x <= 10; x++) {
			for (int y = -10; y <= 10; y++) {
				vec2 offset_pixels = vec2(float(x), float(y));

				if (length(offset_pixels) <= outline_width) {
					vec2 offset_uv = offset_pixels * pixel_size;

					if (texture(TEXTURE, UV + offset_uv).a > 0.0) {
						is_outline = true;
					}
				}
			}
		}

		if (is_outline) {
			vec4 result = outline_color;
			result.rgb *= glow_intensity;
			COLOR = result;
		} else {
			COLOR = vec4(0.0);
		}
	}
}