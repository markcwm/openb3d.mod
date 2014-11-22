// 

uniform samplerCube Env;
uniform float alpha;
varying vec3 Normal;
varying vec3 EyeDir;

uniform int lighttype;
varying vec4 diffuse,ambientGlobal,ambient,ecPos;
varying vec3 normal,halfVector;
 
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
		color = ambientGlobal;
		float att, dist;

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
		color = ambientGlobal;
		float att, dist,spotEffect;
     
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
	
	// diffuse
	vec3 norm = normalize(vec3(Normal.x, -Normal.yz));
	gl_FragColor = vec4(textureCube(Env, norm).rgb, alpha) * vec4(color.rgb, alpha);
}
