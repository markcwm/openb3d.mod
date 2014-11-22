// www.gamedev.net/topic/626244-glsl-pixel-color-based-on-alpha/

varying vec2 texCoords;

void main()
{	
	texCoords = gl_MultiTexCoord0.st;
	
	gl_Position = ftransform();
}
