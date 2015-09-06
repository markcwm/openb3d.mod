// https://tutorialsplay.com/opengl/2014/09/26/lesson-15-water-with-opengl-on-the-gpu-with-glsl/

uniform float waveTime;
uniform float waveWidth;
uniform float waveHeight;
uniform float waveLength;

varying vec3 Normal;
varying vec3 EyeDir;

uniform int lighttype;
varying vec4 diffuse,ambientGlobal,ambient,ecPos;
varying vec3 normal,halfVector;

void main(void)
{
	if (lighttype == 1) // directional light
	{
		/* first transform the normal into eye space and normalize the result */
		normal = normalize(gl_NormalMatrix * gl_Normal);

		/* pass the halfVector to the fragment shader */
		halfVector = gl_LightSource[0].halfVector.xyz;

		/* Compute the diffuse, ambient and globalAmbient terms */
		diffuse = gl_FrontMaterial.diffuse * gl_LightSource[0].diffuse;
		ambient = gl_FrontMaterial.ambient * gl_LightSource[0].ambient;
		ambient += gl_LightModel.ambient * gl_FrontMaterial.ambient;
	}
	
	if (lighttype == 2 || lighttype == 3) // point or spot light
	{
		vec3 aux;

		/* first transform the normal into eye space and normalize the result */
		normal = normalize(gl_NormalMatrix * gl_Normal);

		/* compute the vertex position  in camera space. */
		ecPos = gl_ModelViewMatrix * gl_Vertex;

		/* Normalize the halfVector to pass it to the fragment shader */
		halfVector = gl_LightSource[0].halfVector.xyz;

		/* Compute the diffuse, ambient and globalAmbient terms */
		diffuse = gl_FrontMaterial.diffuse * gl_LightSource[0].diffuse;
		ambient = gl_FrontMaterial.ambient * gl_LightSource[0].ambient;
		ambientGlobal = gl_LightModel.ambient * gl_FrontMaterial.ambient;
	}
	
	// wave deformation
	vec4 v = vec4(gl_Vertex);
	v.y = sin(waveWidth * v.x + waveTime) * cos(waveLength * v.z + waveTime) * waveHeight;
	gl_Position = gl_ModelViewProjectionMatrix * v;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	
	// specular cubemap
	Normal = normalize(-(gl_NormalMatrix * gl_Normal));
	EyeDir = (gl_ModelViewMatrix * gl_Vertex).xyz;
}
