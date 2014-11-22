// 

varying vec3 Normal;
varying vec3 EyeDir;

void main(void)
{
	// specular
	Normal = normalize(-(gl_NormalMatrix * gl_Normal));
	EyeDir = (gl_ModelViewMatrix * gl_Vertex).xyz;
	gl_Position = ftransform();
}
