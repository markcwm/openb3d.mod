// Vertex Shader

varying float NdotL; // The cosine term

void main()
{
// Get the position of the vertex in eye coordinates
vec4 ecPos = gl_ModelViewMatrix * gl_Vertex;
vec3 ecPos3 = (vec3(ecPos)) / ecPos.w;

// The light position from OpenGL
vec3 LightPosition = vec3(gl_LightSource[0].position);

// Transform and normalize the normal
vec3 tnorm = normalize(gl_NormalMatrix * gl_Normal);

// The vector from the vertex to the light source
vec3 lightVec = normalize(LightPosition - ecPos3 );

// Compute the cosine term
NdotL = dot(lightVec,tnorm);

gl_Position = ftransform();
}
