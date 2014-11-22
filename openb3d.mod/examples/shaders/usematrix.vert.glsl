// en.wikibooks.org/wiki/GLSL_Programming/Unity/Shading_in_World_Space

uniform mat4 _Object2World; // definition of a matrix uniform variable 

varying vec4 position_in_world_space;

void main()
{
	position_in_world_space = _Object2World * gl_Vertex;
	// transformation of gl_Vertex from object coordinates to world coordinates;

	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
