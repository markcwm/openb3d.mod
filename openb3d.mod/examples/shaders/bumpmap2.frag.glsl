// en.wikibooks.org/wiki/GLSL_Programming/Blender/Lighting_of_Bumpy_Surfaces
// by Ferret

#define NUM_LIGHTS 2
varying mat3 localSurface2View;
varying vec4 texCoords;
varying vec4 position;
uniform vec3 emission; // 0.0015;
uniform float attspec; // 0.01;
uniform sampler2D colorMap;
uniform sampler2D normalMap;

void main()
{
	vec4 encodedNormal = texture2D(normalMap, vec2(texCoords)); 
	vec4 base = texture2D(colorMap, vec2(texCoords));

	vec3 localCoords = normalize(vec3(2.0, 2.0, 1.0) * vec3(encodedNormal) - vec3(1.0, 1.0, 0.0)); 
	vec3 normalDirection = normalize(localSurface2View * localCoords);

	vec3 viewDirection = -normalize(vec3(position)); 
	vec3 lightDirection;
	float attenuation;
	
	vec3 totalLighting = vec3(gl_LightModel.ambient) * emission;

	for (int i=0;i<NUM_LIGHTS;i++)
	{
		if (0.0 == gl_LightSource[i].position.w)
		{
			attenuation = 1.0;
			lightDirection = normalize(vec3(gl_LightSource[i].position));
		} 
		else // point light or spotlight (or other kind of light) 
		{
			vec3 positionToLightSource = vec3(gl_LightSource[i].position - position);
			float distance = length(positionToLightSource);
			float lightdist = gl_LightSource[i].constantAttenuation
				+ (gl_LightSource[i].linearAttenuation * distance)
				+ (gl_LightSource[i].quadraticAttenuation * sqrt(distance));

			attenuation = 1.0 / lightdist;
			lightDirection = normalize(positionToLightSource);

			if (gl_LightSource[i].spotCutoff <= 90.0)
			{
				float clampedCosine = max(0.0, dot(-lightDirection, gl_LightSource[i].spotDirection));
				
				if (clampedCosine < gl_LightSource[i].spotCosCutoff)
				{
					attenuation = 0.0;
				}
				else
				{
					attenuation = attenuation * pow(clampedCosine, gl_LightSource[i].spotExponent);   
				}
			}
		}

		vec3 ambientLighting = vec3(gl_LightModel.ambient) * emission;

		vec3 diffuseReflection = attenuation
			* vec3(gl_LightSource[i].diffuse)
			* emission
			* max(0.0, dot(normalDirection, lightDirection));
 
		vec3 specularReflection;
		if (dot(normalDirection, lightDirection) < 0.0)
		{
			specularReflection = vec3(0.0, 0.0, 0.0); 
		}
		else
		{
			specularReflection = vec3(attenuation * attspec)
				* vec3(gl_LightSource[i].specular)
				* vec3(gl_FrontMaterial.specular)
				* pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)),
					gl_FrontMaterial.shininess);
		}

		totalLighting += (ambientLighting * vec3(base) + diffuseReflection * vec3(base) + specularReflection);
	}

	gl_FragColor = vec4(totalLighting, 1.0);
}
