// en.wikibooks.org/wiki/GLSL_Programming/Blender/Lighting_of_Bumpy_Surfaces

attribute vec4 tangent;
varying mat3 localSurface2View;
varying vec4 texCoords;
varying vec4 position;
 
void main()
{
	localSurface2View[0] = normalize(vec3(gl_ModelViewMatrix * vec4(vec3(tangent), 0.0)));
	//localSurface2View[0] = normalize(gl_NormalMatrix * tangent.xyz);
	localSurface2View[2] = normalize(gl_NormalMatrix * gl_Normal);
	localSurface2View[1] = normalize(cross(localSurface2View[2], localSurface2View[0]));

	texCoords = gl_MultiTexCoord0;
	position = gl_ModelViewMatrix * gl_Vertex;            
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
