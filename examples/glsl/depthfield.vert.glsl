varying vec4 texCoord0;
varying vec4 texCoord1;

void main()
{	
	texCoord0 = gl_TextureMatrix[0] * gl_MultiTexCoord0;
	texCoord1 = gl_TextureMatrix[1] * gl_MultiTexCoord1;
	
	gl_Position = ftransform();
}
