// unknown source
// by DarkGiver

#define MAX_LIGHTS 8
#define NUM_LIGHTS 2
uniform float texturescale;
varying vec2 Vertex_UV;
varying vec3 Vertex_Normal;
varying vec3 Vertex_LightDir[MAX_LIGHTS];
varying vec4 Vertex_EyeVec;

void main()
{
	Vertex_UV = gl_MultiTexCoord0.xy * texturescale;
	Vertex_Normal = gl_NormalMatrix * gl_Normal;
	vec4 view_vertex = gl_ModelViewMatrix * gl_Vertex;
	
	for (int i=0; i<NUM_LIGHTS; ++i)
	{
		Vertex_LightDir[i] = gl_LightSource[i].position.xyz - view_vertex.xyz;
	}
	
	Vertex_EyeVec = -view_vertex;
	gl_Position = ftransform();
}
