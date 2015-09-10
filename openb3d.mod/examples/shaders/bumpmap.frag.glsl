// www.ozone3d.net/tutorials/bump_mapping.php

#define MAX_LIGHTS 8
#define NUM_LIGHTS 2
varying vec3 lightVec[MAX_LIGHTS];
varying vec3 eyeVec;
varying vec2 texCoord;
uniform sampler2D colorMap;
uniform sampler2D normalMap;
uniform float invRadius; // 0.01 dimness

void main (void)
{

	vec3 vVec = normalize(eyeVec);

	vec4 base = texture2D(colorMap, texCoord);
	vec3 bump = normalize( texture2D(normalMap, texCoord).xyz * 2.0 - 1.0);

	vec4 final_color = vec4(0.0, 0.0, 0.0, 0.0);	
	for (int i=0; i<NUM_LIGHTS; ++i)
	{
		float distSqr = dot(lightVec[i], lightVec[i]);
		float att = clamp(1.0 - invRadius * sqrt(distSqr), 0.0, 1.0);

		vec3 lVec = lightVec[i] * inversesqrt(distSqr);

		vec4 vAmbient = gl_LightSource[i].ambient * gl_FrontMaterial.ambient;

		float diffuse = max( dot(lVec, bump), 0.0 );
		vec4 vDiffuse = gl_LightSource[i].diffuse * gl_FrontMaterial.diffuse * diffuse;

		float specular = pow(clamp(dot(reflect(-lVec, bump), vVec), 0.0, 1.0), gl_FrontMaterial.shininess );
		vec4 vSpecular = gl_LightSource[i].specular * gl_FrontMaterial.specular * specular;

		final_color += ((vAmbient * base + vDiffuse * base + vSpecular) * att);
	}

	gl_FragColor = final_color;
}
