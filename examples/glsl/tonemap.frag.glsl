// Uncharted 2 Tonemap by RonTek
// www.blitzcoder.org

uniform sampler2D texture0;

uniform float ExposureBias;
uniform float MaxWhite;

const float A = 0.22;
const float B = 0.30;
const float C = 0.10;
const float D = 0.20;
const float E = 0.01;
const float F = 0.30;

vec3 Tonemap(vec3 x)
{
   return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}

void main()
{
	vec3 tc = texture2D(texture0, gl_TexCoord[0].st).rgb * ExposureBias;
    vec3 color = Tonemap(max(tc, 0.0)) / Tonemap(vec3(MaxWhite, MaxWhite, MaxWhite));
    gl_FragColor = vec4(color, 1.0);
}
