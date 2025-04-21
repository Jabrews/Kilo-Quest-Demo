shader_type canvas_item;
// "unshaded" so lighting doesn't affect the final output
render_mode unshaded;

// This uniform tells Godot to provide the final screen as a texture
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    // UV is in local coordinates of the ColorRect or node
    // If the node covers the entire screen, UV effectively covers [0..1, 0..1] of the screen
    vec2 uv = UV;

    // Sample the screen texture at these coordinates
    vec4 screen_color = texture(screen_texture, uv);

    // Example: do nothing except display the screen
    COLOR = screen_color;
}
