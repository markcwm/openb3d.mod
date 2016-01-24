// www.gamedev.net/topic/626244-glsl-pixel-color-based-on-alpha/

varying vec2 texCoords;
uniform sampler2D tex;

void main()
{
	vec4 pixel = texture2D(tex, texCoords);
		
	gl_FragColor = pixel;
}
