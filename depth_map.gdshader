shader_type spatial;  // shader for 3d materials - spatial
render_mode unshaded; // ignores light - unshaded

uniform sampler2D depth_tex: hint_depth_texture;



void vertex(){
    POSITION = vec4(VERTEX.xy, 1.0, 1.0); // custom position setting for the vertex (places shader material right in front of camera, so the whole screen is covered)
}

void fragment(){
    float depth = texture(depth_tex, SCREEN_UV).r;
	
	ALBEDO = vec3(pow(depth, 0.7));
    
}