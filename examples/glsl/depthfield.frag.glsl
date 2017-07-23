// from Minib3dPFXNewton0.40.tar.gz by klepto2

varying vec4 texCoord0;
varying vec4 texCoord1;
uniform sampler2D colortex; // tex0
uniform sampler2D depthtex;
uniform float blursize; // 0.002

void main(void)
{
	vec4 blurFactor = texture2D(depthtex, texCoord1.st) * blursize;
	float bf = blurFactor.r;
	vec4 blurSample = vec4(0.0,0.0,0.0,0.0);
	int lo = 3; // 2
	int hi = 2; // 3
	for(int tx =-lo; tx<hi; tx++)
    {
		for(int ty =-lo; ty<hi; ty++)
		{
			vec2 uv = texCoord0.st;
			uv.x = uv.x + float(tx) * bf;
			uv.y = uv.y + float(ty) * bf;
			blurSample = blurSample + texture2D(colortex, uv);
		}	
    }
	float darken = 25.0; // 23
	blurSample = blurSample / darken;
	vec4 texel = blurSample;
	texel.a = 1.0;
	gl_FragColor = texel;
}