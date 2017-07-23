// www.ozone3d.net/tutorials/bump_mapping.php

#define MAX_LIGHTS 8
#define NUM_LIGHTS 2
varying vec3 lightVec[MAX_LIGHTS]; 
varying vec3 eyeVec;
varying vec2 texCoord;
uniform vec3 vTangent; //attribute

void main(void)
{
	gl_Position = ftransform();
	texCoord = gl_MultiTexCoord0.xy;

	vec3 n = normalize(gl_NormalMatrix * gl_Normal);
	vec3 t = normalize(gl_NormalMatrix * vTangent);
	vec3 b = cross(n, t);

	vec3 vVertex = vec3(gl_ModelViewMatrix * gl_Vertex);

	vec3 tmpVec;
	for (int i=0; i<NUM_LIGHTS; ++i)
	{
		tmpVec = gl_LightSource[i].position.xyz - vVertex;

		lightVec[i].x = dot(tmpVec, t);
		lightVec[i].y = dot(tmpVec, b);
		lightVec[i].z = dot(tmpVec, n);
	}

	tmpVec = -vVertex;
	eyeVec.x = dot(tmpVec, t);
	eyeVec.y = dot(tmpVec, b);
	eyeVec.z = dot(tmpVec, n);
}
