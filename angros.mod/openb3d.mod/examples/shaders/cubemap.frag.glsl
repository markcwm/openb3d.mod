// 

uniform samplerCube Env;
uniform float alpha;

varying vec3 Normal;
varying vec3 EyeDir;

void main(void)
{
	// specular
	vec3 reflectDir = reflect(EyeDir, normalize(Normal));
	gl_FragColor = vec4(textureCube(Env, vec3(reflectDir.x, -reflectDir.yz)).rgb, alpha);
}
