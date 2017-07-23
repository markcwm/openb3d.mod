// horizontal gaussian filter
// http://www.geeks3d.com/20100909/shader-library-gaussian-blur-post-processing-filter-in-glsl/

//#version 120

uniform sampler2D sceneTex; // 0

uniform float rt_w; // render target width
uniform float rt_h; // render target height
uniform float vx_offset;

//float offset[3] = float[]( 0.0, 1.3846153846, 3.2307692308 );
//float weight[3] = float[]( 0.2270270270, 0.3162162162, 0.0702702703 );

void main() 
{ 
	vec3 tc = vec3(1.0, 0.0, 0.0);
	
	if (gl_TexCoord[0].x<(vx_offset-0.01)) {
		vec2 uv = gl_TexCoord[0].xy;
		tc = texture2D(sceneTex, uv).rgb * 0.2270270270;
		//for (int i=1; i<3; i++) 
		tc += texture2D(sceneTex, uv + vec2(1.3846153846)/rt_w, 0.0).rgb * 0.3162162162;
		tc += texture2D(sceneTex, uv - vec2(1.3846153846)/rt_w, 0.0).rgb * 0.3162162162;
		tc += texture2D(sceneTex, uv + vec2(3.2307692308)/rt_w, 0.0).rgb * 0.0702702703;
		tc += texture2D(sceneTex, uv - vec2(3.2307692308)/rt_w, 0.0).rgb * 0.0702702703;
	}
	else if (gl_TexCoord[0].x>=(vx_offset+0.01)) {
		tc = texture2D(sceneTex, gl_TexCoord[0].xy).rgb;
	}
	
	gl_FragColor = vec4(tc, 1.0);
}
