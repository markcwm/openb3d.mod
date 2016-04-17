// http://www.eng.utah.edu/~cs5600/slides/GLSL-ATI-Intro.pdf

uniform float density;

uniform int lighttype;
varying vec4 diffuse,ambientGlobal,ambient,ecPos;
varying vec3 normal,halfVector;
varying vec2 texCoords;
uniform sampler2D tex;
uniform vec4 fogColor;
 
void main()
{
	vec4 color = ambient;
	
	if (lighttype == 1) // directional light
	{
		vec3 n,halfV,lightDir;
		float NdotL,NdotHV;

		lightDir = vec3(gl_LightSource[0].position);

		/* The ambient term will always be present */
		// color = ambient;
		
		/* a fragment shader can't write a varying variable, hence we need
		a new variable to store the normalized interpolated normal */
		n = normalize(normal);

		/* compute the dot product between normal and ldir */
		NdotL = max(dot(n,lightDir),0.0);

		if (NdotL > 0.0)
		{
			color += diffuse * NdotL;
			halfV = normalize(halfVector);
			NdotHV = max(dot(n,halfV),0.0);
			color += gl_FrontMaterial.specular
					* gl_LightSource[0].specular
					* pow(NdotHV, gl_FrontMaterial.shininess);
		}
	}
	
	if (lighttype == 2) // point light
	{
		vec3 n,halfV,viewV,lightDir;
		float NdotL,NdotHV;
		float att, dist;
		color = ambientGlobal;

		/* a fragment shader can't write a verying variable, hence we need
		a new variable to store the normalized interpolated normal */
		n = normalize(normal);
 
		// Compute the ligt direction
		lightDir = vec3(gl_LightSource[0].position-ecPos);
 
		/* compute the distance to the light source to a varying variable*/
		dist = length(lightDir);

		/* compute the dot product between normal and ldir */
		NdotL = max(dot(n,normalize(lightDir)),0.0);

		if (NdotL > 0.0)
		{
			att = 1.0 / (gl_LightSource[0].constantAttenuation
						+ gl_LightSource[0].linearAttenuation * dist
						+ gl_LightSource[0].quadraticAttenuation * dist * dist);
						
			color += att * (diffuse * NdotL + ambient);    

			halfV = normalize(halfVector);
			NdotHV = max(dot(n,halfV),0.0);
			color += att * gl_FrontMaterial.specular
						* gl_LightSource[0].specular
						* pow(NdotHV,gl_FrontMaterial.shininess);
		}
	}

	if (lighttype == 3) // spot light
	{
		vec3 n,halfV,viewV,lightDir;
		float NdotL,NdotHV;
		float att, dist,spotEffect;
		color = ambientGlobal;
     
		/* a fragment shader can't write a verying variable, hence we need
		a new variable to store the normalized interpolated normal */
		n = normalize(normal);

		// Compute the ligt direction
		lightDir = vec3(gl_LightSource[0].position-ecPos);

		/* compute the distance to the light source to a varying variable*/
		dist = length(lightDir);

		/* compute the dot product between normal and ldir */
		NdotL = max(dot(n,normalize(lightDir)),0.0);
 
		if (NdotL > 0.0)
		{
			spotEffect = dot(normalize(gl_LightSource[0].spotDirection), normalize(-lightDir));
		
			if (spotEffect > gl_LightSource[0].spotCosCutoff)
			{
				spotEffect = pow(spotEffect, gl_LightSource[0].spotExponent);
				att = spotEffect / (gl_LightSource[0].constantAttenuation
					+ gl_LightSource[0].linearAttenuation * dist
					+ gl_LightSource[0].quadraticAttenuation * dist * dist);
                 
				color += att * (diffuse * NdotL + ambient);

				halfV = normalize(halfVector);
				NdotHV = max(dot(n,halfV),0.0);
				color += att * gl_FrontMaterial.specular
						* gl_LightSource[0].specular
						* pow(NdotHV,gl_FrontMaterial.shininess);
			}
		}
	}
	vec4 pixel = texture2D(tex, texCoords);
	vec4 lpixel = vec4((0.5*color.rgb) * (1.5*pixel.rgb), pixel.a); // lessen lighting color
	
	// calculate 2nd order exponential fog factor based on fragment's Z distance
	const float e = 2.71828;
	float fogFactor = (density * gl_FragCoord.z);
	fogFactor *= fogFactor;
	fogFactor = clamp(pow(e, -fogFactor), 0.0, 1.0);
	
	gl_FragColor = mix(fogColor, lpixel, fogFactor);
}