// https://github.com/chudooder/entanglement/blob/master/shaders

varying vec4 vertColor;
uniform sampler2D texture0;

void main() {
    gl_FragColor = texture2D(texture0, gl_TexCoord[0].st)*vertColor;
}