//

struct FloatArray {
    float Float;
};

#define MAX_LIGHTS 8
#define NUM_LIGHTS 1
uniform sampler2D colorMap; // color map
uniform sampler2D normalMap; // normal map
uniform sampler2D specularMap; // specular map
uniform FloatArray lightradius[MAX_LIGHTS];
uniform vec4 vambient;
varying vec2 Vertex_UV;
varying vec3 Vertex_Normal;
varying vec3 Vertex_LightDir[MAX_LIGHTS];
varying vec4 Vertex_EyeVec;

mat3 cotangent_frame(vec3 N, vec3 p, vec2 uv)
{
    vec3 dp1 = dFdx( p );
    vec3 dp2 = dFdy( p );
    vec2 duv1 = dFdx( uv );
    vec2 duv2 = dFdy( uv );
 
    vec3 dp2perp = cross( dp2, N );
    vec3 dp1perp = cross( N, dp1 );
    vec3 T = dp2perp * duv1.x + dp1perp * duv2.x;
    vec3 B = dp2perp * duv1.y + dp1perp * duv2.y;
 
    float invmax = inversesqrt( max( dot(T,T), dot(B,B) ) );
    return mat3( T * invmax, B * invmax, N );
}

vec3 perturb_normal( vec3 N, vec3 V, vec2 texcoord )
{
	vec3 map = texture2D(normalMap, texcoord ).xyz;
	map = map * 255./127. - 128./127.;
	mat3 TBN = cotangent_frame(N, -V, texcoord);
	return normalize(TBN * map);
}

void main()
{
	float distSqr, att;
	vec3 E, R, L;
	float specular, lambertTerm;

	vec2 uv = Vertex_UV.xy;
	vec3 N = normalize(Vertex_Normal.xyz);
	vec3 V = normalize(Vertex_EyeVec.xyz);
	vec3 PN = perturb_normal(N, V, uv);
  
	vec4 tex01_color = texture2D(colorMap, uv);
	float spec = texture2D(specularMap, uv).x;
	vec4 final_color = vambient * tex01_color;

	for (int i=0; i<NUM_LIGHTS; ++i)
	{
		distSqr = dot(Vertex_LightDir[i], Vertex_LightDir[i]);
		att = clamp(1.0 - lightradius[i].Float * sqrt(distSqr), 0.0, 1.0);
		L = normalize(Vertex_LightDir[i].xyz * inversesqrt(distSqr));  
		lambertTerm = dot(PN, L);
		if (lambertTerm > 0.0)
		{
			final_color += gl_LightSource[i].diffuse * gl_FrontMaterial.diffuse * lambertTerm * tex01_color * att;  
			E = normalize(Vertex_EyeVec.xyz);
			R = reflect(-L, PN);
			specular = pow(max(dot(R, E), 0.0), gl_FrontMaterial.shininess) * spec;
			final_color += gl_LightSource[i].specular * gl_FrontMaterial.specular * specular * att;  
		}
	}
	
	final_color += vambient * tex01_color * att; 
	gl_FragColor = final_color;
}
