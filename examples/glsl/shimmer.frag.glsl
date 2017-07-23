// https://github.com/SFML/SFML/wiki/Source:-HeatHazeShader

uniform sampler2D currentTexture; // Our render texture
uniform sampler2D distortionMapTexture; // Our heat distortion map texture

uniform float time; // Time used to scroll the distortion map
uniform float distortionFactor; // Factor used to control severity of the effect
uniform float riseFactor; // Factor used to control how fast air rises

void main()
{
	vec2 coords = gl_TexCoord[0].st;
	//vec2 coords = vec2(gl_TexCoord[0].s, -gl_TexCoord[0].t); // flip texture
    vec2 distortionMapCoordinate = coords;

    // We use the time value to scroll our distortion texture upwards
    // Since we enabled texture repeating, OpenGL takes care of
    // coordinates that lie outside of [0, 1] by discarding
    // the integer part and keeping the fractional part
    // Basically performing a "floating point modulo 1"
    // 1.1 = 0.1, 2.4 = 0.4, 10.3 = 0.3 etc.
    distortionMapCoordinate.t -= time * riseFactor;

    vec4 distortionMapValue = texture2D(distortionMapTexture, distortionMapCoordinate);

    // The values are normalized by OpenGL to lie in the range [0, 1]
    // We want negative offsets too, so we subtract 0.5 and multiply by 2
    // We end up with values in the range [-1, 1]
    vec2 distortionPositionOffset = distortionMapValue.xy;
    distortionPositionOffset -= vec2(0.5, 0.5);
    distortionPositionOffset *= 2.0;

    // The factor scales the offset and thus controls the severity
    distortionPositionOffset *= distortionFactor;

    // The latter 2 channels of the texture are unused... be creative
    vec2 distortionUnused = distortionMapValue.zw;

    // Since we all know that hot air rises and cools,
    // the effect loses its severity the higher up we get
    // We use the t (a.k.a. y) texture coordinate of the original texture
    // to tell us how "high up" we are and damp accordingly
    // Remember, OpenGL 0 is at the bottom
    distortionPositionOffset *= gl_TexCoord[0].t; // was 1.f - t

    vec2 distortedTextureCoordinate = coords + distortionPositionOffset;

    gl_FragColor = gl_Color * texture2D(currentTexture, distortedTextureCoordinate);
}