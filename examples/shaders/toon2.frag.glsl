// Fragment Shader

varying float NdotL; // Interpolated over the face

void main()
{
vec3 SurfaceColor = vec3(gl_FrontMaterial.diffuse);

// Produces the stair step pattern
float scale = ceil( 3.0 * NdotL) / 3.0;

gl_FragColor = vec4(SurfaceColor * scale, 1.0 );
}
