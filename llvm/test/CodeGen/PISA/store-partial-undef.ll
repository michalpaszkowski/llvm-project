; RUN: llc < %s -march=pisa -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs | FileCheck --check-prefix=O0 %s

; Verify that stores of partially-undef vectors with more than 4 elements
; (requiring v4 + scalar split) compile without asserting in RegManager

define pisa_kernel void @store_partial_undef(ptr addrspace(1) %dst) {
; O0-LABEL: @store_partial_undef(
; O0-SAME: .param[8] .addrspace(global) [[PARAM_ARG0:%[-a-zA-Z$._0-9]+]]
; O0: 	.reg .64b [[R64_D0:%[-a-zA-Z$._0-9]+]];
; O0-NEXT: 	.reg .32b %w<0~6>;
; O0-NEXT: 	.reg .v5.32b [[VR5_32_V5W0:%[-a-zA-Z$._0-9]+]];
; O0-NEXT: 	.reg .v4.32b [[VR4_32_V4W0:%[-a-zA-Z$._0-9]+]], [[VR4_32_V4W1:%[-a-zA-Z$._0-9]+]], [[VR4_32_V4W2:%[-a-zA-Z$._0-9]+]], [[VR4_32_V4W3:%[-a-zA-Z$._0-9]+]];
; O0: 	ld.param.64b [[R64_D0]], [[[PARAM_ARG0]]];
; O0-NEXT: 	mov.32b 	%w0, {{0x00000000|0}};
; O0-NEXT: 	mov.32b 	[[VR5_32_V5W0]].x, %w0;
; O0-NEXT: 	mov.32b 	%w1, [[VR5_32_V5W0]].x;
; O0-NEXT: 	mov.32b 	%w2, [[VR5_32_V5W0]].y;
; O0-NEXT: 	mov.32b 	%w3, [[VR5_32_V5W0]].z;
; O0-NEXT: 	mov.32b 	%w4, [[VR5_32_V5W0]].w;
; O0-NEXT: 	extract.4.32b 	%w5, [[VR5_32_V5W0]];
; O0-NEXT: 	mov.32b 	[[VR4_32_V4W0]].x, %w1;
; O0-NEXT: 	mov.128b 	[[VR4_32_V4W1]].xyzw, [[VR4_32_V4W0]].xyzw;
; O0-NEXT: 	mov.32b 	[[VR4_32_V4W1]].y, %w2;
; O0-NEXT: 	mov.128b 	[[VR4_32_V4W2]].xyzw, [[VR4_32_V4W1]].xyzw;
; O0-NEXT: 	mov.32b 	[[VR4_32_V4W2]].z, %w3;
; O0-NEXT: 	mov.128b 	[[VR4_32_V4W3]].xyzw, [[VR4_32_V4W2]].xyzw;
; O0-NEXT: 	mov.32b 	[[VR4_32_V4W3]].w, %w4;
; O0-NEXT: 	st.global.v4.32b	 [[[R64_D0]]], [[VR4_32_V4W3]];
; O0-NEXT: 	st.global.32b	 [[[R64_D0]] + 16], %w5;
; O0-NEXT: 	return;
;
; CHECK-LABEL: @store_partial_undef(
; CHECK:         ld.param.64b
; CHECK:         mov.32b  {{%[-a-zA-Z$._0-9]+}}.x,
; CHECK:         st.global.v4.32b
; CHECK:         st.global.32b
  store <5 x float> <float 0.000000e+00, float undef, float undef, float undef, float undef>, ptr addrspace(1) %dst, align 32
  ret void
}

; Verify that when only one lane of a consecutive pair is undef, the merged
; COPY source does not get the undef flag (both must be undef for propagation).
; The mov.64b instructions prove OptimizeSubregAccess merged the lane copies.

define pisa_kernel void @store_mixed_undef(ptr addrspace(1) %dst) {
; O0-LABEL: @store_mixed_undef(
; O0-SAME: .param[8] .addrspace(global) [[PARAM_ARG0:%[-a-zA-Z$._0-9]+]]
; O0: 	.reg .64b [[R64_D0:%[-a-zA-Z$._0-9]+]];
; O0-NEXT: 	.reg .32b %w<0~9>;
; O0-NEXT: 	.reg .v5.32b [[VR5_32_V5W0:%[-a-zA-Z$._0-9]+]], [[VR5_32_V5W1:%[-a-zA-Z$._0-9]+]], [[VR5_32_V5W2:%[-a-zA-Z$._0-9]+]], [[VR5_32_V5W3:%[-a-zA-Z$._0-9]+]], [[VR5_32_V5W4:%[-a-zA-Z$._0-9]+]];
; O0-NEXT: 	.reg .v4.32b [[VR4_32_V4W0:%[-a-zA-Z$._0-9]+]], [[VR4_32_V4W1:%[-a-zA-Z$._0-9]+]], [[VR4_32_V4W2:%[-a-zA-Z$._0-9]+]], [[VR4_32_V4W3:%[-a-zA-Z$._0-9]+]];
; O0: 	ld.param.64b [[R64_D0]], [[[PARAM_ARG0]]];
; O0-NEXT: 	mov.32b 	%w0, {{0x3F800000|1065353216}};
; O0-NEXT: 	mov.32b 	%w1, {{0x40000000|1073741824}};
; O0-NEXT: 	mov.32b 	%w2, {{0x40400000|1077936128}};
; O0-NEXT: 	insert.0.32b 	[[VR5_32_V5W0]], %w0;
; O0-NEXT: 	extract.0.v5.32b 	[[VR5_32_V5W1]], [[VR5_32_V5W0]];
; O0-NEXT: 	insert.1.32b 	[[VR5_32_V5W1]], %w3;
; O0-NEXT: 	extract.0.v5.32b 	[[VR5_32_V5W2]], [[VR5_32_V5W1]];
; O0-NEXT: 	insert.2.32b 	[[VR5_32_V5W2]], %w1;
; O0-NEXT: 	extract.0.v5.32b 	[[VR5_32_V5W3]], [[VR5_32_V5W2]];
; O0-NEXT: 	insert.3.32b 	[[VR5_32_V5W3]], %w3;
; O0-NEXT: 	extract.0.v5.32b 	[[VR5_32_V5W4]], [[VR5_32_V5W3]];
; O0-NEXT: 	insert.4.32b 	[[VR5_32_V5W4]], %w2;
; O0-NEXT: 	mov.32b 	%w4, [[VR5_32_V5W4]].x;
; O0-NEXT: 	mov.32b 	%w5, [[VR5_32_V5W4]].y;
; O0-NEXT: 	mov.32b 	%w6, [[VR5_32_V5W4]].z;
; O0-NEXT: 	mov.32b 	%w7, [[VR5_32_V5W4]].w;
; O0-NEXT: 	extract.4.32b 	%w8, [[VR5_32_V5W4]];
; O0-NEXT: 	mov.32b 	[[VR4_32_V4W0]].x, %w4;
; O0-NEXT: 	mov.128b 	[[VR4_32_V4W1]].xyzw, [[VR4_32_V4W0]].xyzw;
; O0-NEXT: 	mov.32b 	[[VR4_32_V4W1]].y, %w5;
; O0-NEXT: 	mov.128b 	[[VR4_32_V4W2]].xyzw, [[VR4_32_V4W1]].xyzw;
; O0-NEXT: 	mov.32b 	[[VR4_32_V4W2]].z, %w6;
; O0-NEXT: 	mov.128b 	[[VR4_32_V4W3]].xyzw, [[VR4_32_V4W2]].xyzw;
; O0-NEXT: 	mov.32b 	[[VR4_32_V4W3]].w, %w7;
; O0-NEXT: 	st.global.v4.32b	 [[[R64_D0]]], [[VR4_32_V4W3]];
; O0-NEXT: 	st.global.32b	 [[[R64_D0]] + 16], %w8;
; O0-NEXT: 	return;
;
; CHECK-LABEL: @store_mixed_undef(
; CHECK:         mov.64b {{%[-a-zA-Z$._0-9]+}}.xy, {{%[-a-zA-Z$._0-9]+}}.xy
; CHECK:         mov.64b {{%[-a-zA-Z$._0-9]+}}.zw, {{%[-a-zA-Z$._0-9]+}}.zw
; CHECK:         st.global.v4.32b
; CHECK:         st.global.32b
  store <5 x float> <float 1.000000e+00, float undef, float 2.000000e+00, float undef, float 3.000000e+00>, ptr addrspace(1) %dst, align 32
  ret void
}
