precision mediump float;
uniform sampler2D tex;
in vec2 v_texcoord;
out vec4 fragColor;

void main() {
    vec4 color = texture(tex, v_texcoord);
    fragColor = vec4(vec3(1.0) - color.rgb, color.a);
}
