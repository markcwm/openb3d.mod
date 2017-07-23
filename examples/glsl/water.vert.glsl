// https://tutorialsplay.com/opengl/2014/09/26/lesson-15-water-with-opengl-on-the-gpu-with-glsl/

uniform float waveTime;
uniform float waveWidth;
uniform float waveHeight;
uniform float waveLength;

varying vec3 Normal;
varying vec3 EyeDir;

void main(void)
{
	vec4 v = vec4(gl_Vertex);
	v.y = sin(waveWidth * v.x + waveTime) * cos(waveLength * v.z + waveTime) * waveHeight;
	gl_Position = gl_ModelViewProjectionMatrix * v;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	
	// specular cubemap
	Normal = normalize(-(gl_NormalMatrix * gl_Normal));
	EyeDir = (gl_ModelViewMatrix * gl_Vertex).xyz;
}
