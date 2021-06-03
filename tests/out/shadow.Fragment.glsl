#version 310 es

precision highp float;

struct Light {
    mat4x4 proj;
    vec4 pos;
    vec4 color;
};

uniform Globals_block_0 {
    uvec4 num_lights;
} _group_0_binding_0;
readonly buffer Lights_block_1 {
    Light data[];
} _group_0_binding_1;
uniform highp sampler2DArrayShadow _group_0_binding_2;

smooth layout(location = 0) in vec3 _vs2fs_location0;
smooth layout(location = 1) in vec4 _vs2fs_location1;
layout(location = 0) out vec4 _fs2p_location0;

float fetch_shadow(uint light_id, vec4 homogeneous_coords) {
    if((homogeneous_coords.w <= 0.0)) {
        return 1.0;
    }
    vec2 flip_correction = vec2(0.5, -0.5);
    vec2 light_local = (((homogeneous_coords.xy * flip_correction) / vec2(homogeneous_coords.w)) + vec2(0.5, 0.5));
    float _expr26 = textureGrad(_group_0_binding_2, vec4(light_local, int(light_id), (homogeneous_coords.z / homogeneous_coords.w)), vec2(0, 0), vec2(0,0));
    return _expr26;
}

void main() {
    vec3 raw_normal = _vs2fs_location0;
    vec4 position = _vs2fs_location1;
    vec3 color1 = vec3(0.05, 0.05, 0.05);
    uint i = 0u;
    vec3 normal = normalize(raw_normal);
    while(true) {
        if((i >= min(_group_0_binding_0.num_lights.x, 10u))) {
            break;
        }
        Light light = _group_0_binding_1.data[i];
        float _expr25 = fetch_shadow(i, (light.proj * position));
        vec3 light_dir = normalize((light.pos.xyz - position.xyz));
        float diffuse = max(0.0, dot(normal, light_dir));
        color1 = (color1 + ((_expr25 * diffuse) * light.color.xyz));
        i = (i + 1u);
    }
    _fs2p_location0 = vec4(color1, 1.0);
    return;
}

