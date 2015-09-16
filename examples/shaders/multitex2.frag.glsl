// www.opengl.org/wiki/Multitexture_with_GLSL

uniform sampler2D Texture0;
uniform sampler2D Texture1;
uniform sampler2D Texture2; // Mask
varying vec2 TexCoord0;

void main()
{  
	vec4 texel0, texel1, texel2, resultColor;

	texel0 = texture2D(Texture0, TexCoord0);
	texel1 = texture2D(Texture1, TexCoord0);
	texel2 = texture2D(Texture2, TexCoord0);

	resultColor = mix(texel0, texel1, texel2.r);
	gl_FragColor = resultColor;
}
