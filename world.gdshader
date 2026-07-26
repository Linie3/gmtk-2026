shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 blackout_position = vec2(0.0, 0.0); // World coordinates
uniform bool blackout_enabled = false;
uniform float radius : hint_range(0.0, 10000.0) = 200.0;  // World units
uniform float softness : hint_range(0.0, 100000.0) = 80.0;

// Pass the inverse canvas matrix directly from script
uniform mat4 global_transform_inv;

void fragment() {
    vec4 tex_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    if (blackout_enabled) {
        // Convert SCREEN_UV (0..1) to viewport pixel coordinates
        vec2 screen_pixel = SCREEN_UV / SCREEN_PIXEL_SIZE;

        // Transform screen pixel to exact world position
        vec2 world_pos = (global_transform_inv * vec4(screen_pixel, 0.0, 1.0)).xy;

        float dist = distance(world_pos, blackout_position);
        float mask = smoothstep(radius, radius - softness, dist);

        tex_color.rgb *= mask;
    }

    COLOR = tex_color;
}