// 

varying vec3 Normal;
varying vec3 EyeDir;

void main(void)
{
	// diffuse
	Normal = gl_NormalMatrix * gl_Normal;
	gl_Position = ftransform();
}
