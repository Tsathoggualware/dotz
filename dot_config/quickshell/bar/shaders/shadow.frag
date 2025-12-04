#version 330 core
in vec2 qt_TexCoord0;
uniform sampler2D source;
out vec4 fragColor;

void main() {
    vec4 base = texture(source, qt_TexCoord0);
    vec4 blur = vec4(0.0);

    blur += texture(source, qt_TexCoord0 + vec2( 1.0/512.0,  1.0/512.0));
    blur += texture(source, qt_TexCoord0 + vec2(-1.0/512.0, -1.0/512.0));
    blur += texture(source, qt_TexCoord0 + vec2( 1.0/512.0, -1.0/512.0));
    blur += texture(source, qt_TexCoord0 + vec2(-1.0/512.0,  1.0/512.0));

    fragColor = vec4(0,0,0,0.7) * (blur.a * 0.25) + base;
}
