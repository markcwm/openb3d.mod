varying vec2 texCoords;

void main()
{	
	texCoords = gl_MultiTexCoord0.st; // gl_TexCoord[0]
	
	gl_Position = ftransform();
}
