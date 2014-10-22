// 

uniform samplerCube Env;
uniform float alpha;

varying vec3 Normal;
varying vec3 EyeDir;

void main(void)
{
	// diffuse
	vec3 norm = normalize(vec3(Normal.x, -Normal.yz));
	gl_FragColor = vec4(textureCube(Env, norm).rgb, alpha);
}
