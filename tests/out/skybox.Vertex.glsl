#version 310 es

precision highp float;

struct VertexOutput {
    vec4 position;
    vec3 uv;
};

uniform Data_block_0 {
    mat4x4 proj_inv;
    mat4x4 view;
} _group_0_binding_0;
smooth layout(location = 0) out vec3 _vs2fs_location0;

void main() {
    uint vertex_index = uint(gl_VertexID);
    int tmp1_;
    int tmp2_;
    tmp1_ = (int(vertex_index) / 2);
    tmp2_ = (int(vertex_index) & 1);
    vec4 pos = vec4(((float(tmp1_) * 4.0) - 1.0), ((float(tmp2_) * 4.0) - 1.0), 0.0, 1.0);
    mat3x3 inv_model_view = transpose(mat3x3(_group_0_binding_0.view[0].xyz, _group_0_binding_0.view[1].xyz, _group_0_binding_0.view[2].xyz));
    vec4 unprojected = (_group_0_binding_0.proj_inv * pos);
    VertexOutput _tmp_return = VertexOutput(pos, (inv_model_view * unprojected.xyz));
    gl_Position = _tmp_return.position;
    _vs2fs_location0 = _tmp_return.uv;
    return;
}

