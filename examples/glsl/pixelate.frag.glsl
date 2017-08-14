// http://www.geeks3d.com/20101029/shader-library-pixelation-post-processing-effect-glsl/

uniform sampler2D sceneTex; // texture 0
//uniform float vx_offset; // offset of vertical red line
uniform float rt_w; // render target w
uniform float rt_h; // render target h
uniform float pixel_w; // w of low res pixel eg. 15.0
uniform float pixel_h; // h of low res pixel eg. 10.0

void main()
{
	vec2 uv = gl_TexCoord[0].xy;
	vec3 tc = vec3(1.0, 0.0, 0.0);
	float vx_offset = 1.0; // disable line
	
	if (uv.x < (vx_offset - 0.005))
	{
		float dx = pixel_w * (1.0 / rt_w);
		float dy = pixel_h * (1.0 / rt_h);
		vec2 coord = vec2(dx * floor(uv.x / dx), dy * floor(uv.y / dy));
		tc = texture2D(sceneTex, coord).rgb;
	}
	else if (uv.x >= (vx_offset + 0.005))
	{
		tc = texture2D(sceneTex, uv).rgb;
	}
	
	gl_FragColor = vec4(tc, 1.0);
}