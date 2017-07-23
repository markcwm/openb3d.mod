// www.gamedev.net/topic/626244-glsl-pixel-color-based-on-alpha/

varying vec2 texCoords;
uniform sampler2D tex;
uniform sampler2D alphatex;

void main()
{
	vec4 pixel = texture2D(tex, texCoords);
	vec4 alpha_color = texture2D(alphatex, texCoords);
	pixel.a = alpha_color.r;
	
	gl_FragColor = pixel;
}
