// Bloom (Fake HDR) Effect by RonTek
// www.blitzcoder.org

uniform sampler2D texture0;

// HDR Setting
uniform float exposure; // default 20.0
// Bloom Settings
uniform float GlareSize; // 0.002 is good
uniform float Power; // 0.25 is good

void main()
{   

    vec4 texel = texture2D(texture0, gl_TexCoord[0].st);

    float Y = dot(vec4(0.30, 0.59, 0.11, 0.0), texel);
    Y = Y * exposure;
    Y = Y / (Y + 1.0);
    texel.rgb = texel.rgb * Y; 
    vec4 hdr = vec4(texel.rgb, 1.0);

    vec4 sum = vec4(0);
    int i, j;

    for(i = -4; i < 4; i++)
    {
        for (j = -3; j < 3; j++)
        {
            sum += texture2D(texture0, gl_TexCoord[0].st + vec2(j, i) * GlareSize) * Power;
        }
    }

    //HDR
    vec4 base_color = hdr;

    if (base_color.r < 0.3)
    {
        gl_FragColor = sum * sum * 0.012 + base_color;
    }
    else 
    {
        if(base_color.r < 0.5)
        {
            gl_FragColor = sum * sum * 0.009 + base_color;
        }
        else
        {
            gl_FragColor = sum * sum * 0.0075 + base_color;
        }
    }   

}
