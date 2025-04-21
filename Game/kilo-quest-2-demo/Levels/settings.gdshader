shader_type canvas_item;

uniform float time_speed : hint_range(0.0, 10.0) = 1.0;
uniform float zoom : hint_range(0.1, 10.0) = 2.0;
uniform float desaturation : hint_range(0.0, 1.0) = 0.5; // Control how desaturated the colors are

void fragment() {
    // Map UV coordinates from 0.0-1.0 to -1.0 to 1.0 so that the center is at (0,0)
    vec2 uv = UV * 2.0 - 1.0;

    // Animate using the TIME uniform
    float t = TIME * time_speed;

    // Convert UV to polar coordinates
    float r = length(uv);
    float a = atan(uv.y, uv.x);

    // Create a swirling pattern using sine functions
    float pattern = sin(zoom * r - t + sin(a * 5.0));

    // Generate base color with an emphasis on blues and purples:
    // - The red channel uses a moderate amplitude.
    // - The green channel has a lower amplitude to reduce its influence.
    // - The blue channel has a higher amplitude.
    vec3 col;
    col.r = 0.5 + 0.3 * sin(t + pattern * 6.2831 + 0.0);
    col.g = 0.5 + 0.1 * sin(t + pattern * 6.2831 + 2.094); // Reduced green
    col.b = 0.5 + 0.4 * sin(t + pattern * 6.2831 + 4.188);

    // Desaturate the color by blending it with its grayscale version.
    // First, calculate a simple grayscale value:
    float gray = dot(col, vec3(0.333, 0.333, 0.333));
    // Then mix the original color with the gray value based on the 'desaturation' uniform.
    col = mix(col, vec3(gray), desaturation);

    // Output the final color
    COLOR = vec4(col, 1.0);
}
