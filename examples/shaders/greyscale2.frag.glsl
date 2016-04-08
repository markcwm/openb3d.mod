// https://github.com/chudooder/entanglement/blob/master/shaders

varying vec4 vertColor;
uniform sampler2D texture0;

void main() {
	vec4 col = texture2D(texture0, vec2(gl_TexCoord[0].s, -gl_TexCoord[0].t))*vertColor;
	float luminance = 0.2126*col.r + 0.7152*col.g + 0.0722*col.b;
    gl_FragColor = vec4(luminance, luminance, luminance, col.a);
}