// www.opengl.org/wiki/Multitexture_with_GLSL

varying vec2 TexCoord0;

void main()
{
	TexCoord0 = gl_MultiTexCoord0.st;

	gl_Position = ftransform();
}
