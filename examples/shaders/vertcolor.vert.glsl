
varying vec3 vertex_color;

void main()
{
	gl_Position = ftransform();
	vertex_color = gl_Vertex.xyz; // Example of how to use swizzling.
	// This is the same as vertex_color = vec3(gl_Vertex);
}
