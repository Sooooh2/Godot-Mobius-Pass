shader_type spatial;  // shader for 3d materials - spatial
render_mode unshaded; // ignores light - unshaded

uniform sampler2D depth_tex:  hint_depth_texture;
uniform sampler2D screen_tex: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D normal_tex: hint_normal_roughness_texture, filter_linear_mipmap;

uniform vec3 line_color: source_color = vec3(0.0); // color for the lines
uniform vec3 background_color: source_color = vec3(0.6);     // background color
uniform float threshold : hint_range(0.0, 0.00000, 0.01) = 0.00005;   // threshold for edge detection


const mat3 sobel_x = mat3(               // Sobel filter for edge detection in x direction
	vec3(1.0, 2.0, 1.0),
	vec3(0.0, 0.0, 0.0),
	vec3(-1.0, -2.0, -1.0)
);
const mat3 sobel_y = mat3(               // filter for edge detection in y direction
	vec3(-1.0, 0.0, 1.0),
	vec3(-2.0, 0.0, 2.0),
	vec3(-1.0, 0.0, 1.0)
);


void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0); // custom position setting for the vertex (places shader material right in front of camera, so the whole screen is covered)
}
void fragment() {
    float depth = texture(depth_tex, SCREEN_UV).r;      // get depth value from the depth texture

	vec3 normal = texture(normal_tex, SCREEN_UV).rgb;   // get normal from the normal texture
	normal = normal * 2.0 - 1.0;                        // convert normal from [0,1] to [-1,1] range
	vec2 pixel_size = 1.0 / VIEWPORT_SIZE;              // calculate pixel size based on viewport size
	float linear_depth = 1.0 / (depth * INV_PROJECTION_MATRIX[2].w + INV_PROJECTION_MATRIX[3].w) + VERTEX.z;     // Normalize depth (adjust denominator based on scene scale)


    linear_depth = clamp(pow(depth,0.5), 0.0, 0.2);     // adjust depth value to a range suitable for color mapping

	vec3 colorA = vec3(1.0,0.647,0.0);          //far color
	vec3 colorB = vec3(0.5,0.0,0.5);            //near color
	vec3 colorC = vec3(0.0,0.0,1.0);            //mid color
	vec3 final_color;                           // final color to be outputted
	float t;                                    // interpolation factor
	if (linear_depth < 0.5) {                   // if depth is less than 0.5, interpolate between colorA and colorB
	    t = pow(linear_depth * 3.0, 0.5);
	    final_color = mix(colorA, colorB, t);
	} else {                                    // else, interpolate between colorB and colorC
	    t = pow((linear_depth) * 2.0, 5.2);
	    final_color = mix(colorB, colorC, t);
	}

	mat3 pixels;
	for (int x = -1; x <= 1; x++) {            // loop through a 3x3 grid of pixels around the current pixel
		for (int y = -1; y <= 1; y++) {
			vec2 offset = pixel_size * vec2(float(x), float(y));                             // calculate offset for the current pixel
			vec3 sample_normal = texture(normal_tex, SCREEN_UV + offset).rgb * 2.0 - 1.0;    // sample the normal texture at the offset position
			pixels[x + 1][y + 1] = length(sample_normal - normal);                           // calculate the difference in normals and store it in the pixels matrix
		}
	}

	float gx = 0.0;
	float gy = 0.0;
	for (int i = 0; i < 3; i++) {             // loop through the 3x3 pixels matrix
		for (int j = 0; j < 3; j++) {
			gx += sobel_x[i][j] * pixels[i][j];      // apply Sobel filter in x direction
			gy += sobel_y[i][j] * pixels[i][j];      // apply Sobel filter in y direction
		}
	}

	float sobel = sqrt(gx * gx + gy * gy);
	vec3 scene_color = texture(screen_tex, SCREEN_UV).rgb;


	// Use smoothstep for anti-aliased edge factor
	float edge_factor = smoothstep(threshold - 0.1, threshold + 0.1, sobel);


	// Blend stylized depth color with scene color
	vec3 stylized_color = mix(scene_color, final_color, 0.6);

	// Then overlay the edge line
	ALBEDO = mix(stylized_color, line_color, edge_factor);
       // calculate the magnitude of the gradient vector
	//ALBEDO = sobel > threshold ? line_color : final_color;   // decides where the line color is applied based on the Sobel value and threshold
}
