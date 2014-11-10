//@fragment

uniform sampler2D bb_ColorBuffer;
uniform sampler2D bb_DepthBuffer;
uniform float bright;
uniform float bb_zNear;
uniform float bb_zFar;
varying vec2 texCoords;

void main ()
{ 

	vec4 pixel = texture2D(bb_ColorBuffer, texCoords);

	float fragz = texture2D(bb_DepthBuffer, texCoords).r;

	fragz = bb_zNear * bb_zFar / (fragz * (bb_zNear - bb_zFar) + bb_zFar);

	pixel.r = clamp ((1.0 / fragz) * bright, 0.0, 1.0);
	pixel.g = clamp ((1.0 / fragz) * bright, 0.0, 1.0);
	pixel.b = clamp ((1.0 / fragz) * bright, 0.0, 1.0);

	gl_FragColor = pixel;

}
