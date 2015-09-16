//@fragment

uniform sampler2D bb_ColorBuffer;
uniform sampler2D bb_DepthBuffer;
uniform float bright;
uniform float bb_zNear;
uniform float bb_zFar;
uniform vec2 resolution;
uniform float yoffset;

void main ()
{ 
	vec2 screen = vec2(gl_FragCoord.x, gl_FragCoord.y + yoffset);
	vec4 pixel = texture2D(bb_ColorBuffer, screen / resolution.xy);
	float fragz = texture2D(bb_DepthBuffer, screen / resolution.xy).r;
	
	fragz = bb_zNear * bb_zFar / (fragz * (bb_zNear - bb_zFar) + bb_zFar);

	pixel.r = clamp ((1.0 / fragz) * bright, 0.0, 1.0);
	pixel.g = clamp ((1.0 / fragz) * bright, 0.0, 1.0);
	pixel.b = clamp ((1.0 / fragz) * bright, 0.0, 1.0);

	gl_FragColor = pixel;

}
