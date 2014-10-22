// ricardocabello.com/blog/post/714

attribute vec3 position;

void main()
{
	gl_TexCoord[0] = gl_MultiTexCoord0; // added

	gl_Position = ftransform(); // added
	//gl_Position = vec4( position, 1.0 );
}
