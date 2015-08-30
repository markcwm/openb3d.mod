// https://tutorialsplay.com/opengl/2014/09/26/lesson-15-water-with-opengl-on-the-gpu-with-glsl/
 
uniform sampler2D color_texture;

uniform samplerCube Env;
uniform float alpha;
varying vec3 Normal;
varying vec3 EyeDir;

uniform vec4 texmix;
uniform float uvdrag;

void main() {
	// Set the output color of our current pixel
	vec4 tex = texture2D(color_texture, gl_TexCoord[0].st + uvdrag);
	
	// specular cubemap
	vec3 reflectDir = reflect(EyeDir, normalize(Normal));
	vec4 pixel = textureCube(Env, vec3(-reflectDir.x, -reflectDir.y, reflectDir.z));
	gl_FragColor = (texmix.x * vec4(pixel.rgb, alpha)) + (texmix.y * vec4(tex.rgb, alpha));
}
