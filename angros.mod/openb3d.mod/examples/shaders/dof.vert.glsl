//@vertex 

varying vec2 texCoords;

void main()
{
	texCoords = gl_MultiTexCoord0.st;
	
	//gl_Position = bb_Vertex;
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex; 
} 
