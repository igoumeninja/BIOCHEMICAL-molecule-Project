#version 120
#extension GL_ARB_texture_rectangle : enable
#ifdef GL_ES
precision highp float;
#endif

uniform sampler2DRect tex0;
uniform vec2 resolution;
uniform float time;

void main(void)
{
    vec2 q = gl_FragCoord.xy / resolution.xy;
    vec2 uv = (0.5 + (q-0.5)*(0.9 + 0.1*sin(0.2*time)));

    vec3 oricol = texture2DRect(tex0,vec2(q.x*resolution.x,q.y*resolution.y)).xyz;
    vec3 col;

    col.r = texture2DRect(tex0,vec2((uv.x*resolution.x)+3,(uv.y*resolution.y))).x;
    col.g = texture2DRect(tex0,vec2((uv.x*resolution.x),(uv.y*resolution.y))).y;
    col.b = texture2DRect(tex0,vec2((uv.x*resolution.x)-3,(uv.y*resolution.y))).z;

    col = clamp(col*0.5+0.5*col*col*1.2,0.0,1.0);

    col *= 0.5 + 0.5*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y);

    col *= vec3(0.8,1.0,0.7);

    col *= 0.9+0.1*sin(10.0*time+uv.y*1000.0);

    col *= 0.97+0.03*sin(110.0*time);

    float comp = smoothstep( 0.2, 0.7, sin(time) );
    col = mix( col, oricol, clamp(-2.0+2.0*q.x+3.0*comp,0.0,1.0) );

    gl_FragColor = vec4(col,1.0);
}