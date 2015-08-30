// https://tutorialsplay.com/opengl/2014/09/26/lesson-15-water-with-opengl-on-the-gpu-with-glsl/
 
uniform sampler2D color_texture;

uniform samplerCube Env;
uniform float alpha;
varying vec3 Normal;
varying vec3 EyeDir;

uniform float texmix;
uniform float uvdrag;

void main() {
	// Set the output color of our current pixel
	vec4 color = texture2D(color_texture, gl_TexCoord[0].st + uvdrag);
	
	// specular cubemap
	vec3 reflectDir = reflect(EyeDir, normalize(Normal));
	vec4 pixel = textureCube(Env, vec3(-reflectDir.x, -reflectDir.y, reflectDir.z));
	gl_FragColor = (texmix * vec4(pixel.rgb, alpha)) + ((1.0-texmix) * vec4(color.rgb, alpha));
}
