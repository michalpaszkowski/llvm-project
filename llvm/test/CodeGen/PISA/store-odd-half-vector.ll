; RUN: llc -march=pisa %s -o - | FileCheck %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs | FileCheck --check-prefix=O0 %s

; Verify that stores of odd-sized half vectors (>4 elements, non-power-of-2
; total bits) compile correctly. These require custom G_BITCAST legalization
; to decompose element-wise, avoiding illegal G_UNMERGE_VALUES.

define void @test_store_v5f16(<5 x half> %val, ptr addrspace(4) %addr) {
; O0-LABEL: void @test_store_v5f16(
; O0-SAME: .reg .32b [[R32_W0:%[-a-zA-Z$._0-9]+]]
; O0-SAME: .reg .32b [[R32_W1:%[-a-zA-Z$._0-9]+]]
; O0: 	.reg .v4.16b [[VR4_16_V4H0:%[-a-zA-Z$._0-9]+]], [[VR4_16_V4H1:%[-a-zA-Z$._0-9]+]], [[VR4_16_V4H2:%[-a-zA-Z$._0-9]+]], [[VR4_16_V4H3:%[-a-zA-Z$._0-9]+]], [[VR4_16_V4H4:%[-a-zA-Z$._0-9]+]];
; O0-NEXT: 	.reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]], [[R16_H1:%[-a-zA-Z$._0-9]+]], [[R16_H2:%[-a-zA-Z$._0-9]+]], [[R16_H3:%[-a-zA-Z$._0-9]+]], [[R16_H4:%[-a-zA-Z$._0-9]+]];
; O0: 	ld.private.v4.16b	 [[VR4_16_V4H0]], [[[R32_W0]]];
; O0-NEXT: 	ld.private.16b	 [[R16_H0]], [[[R32_W0]] + 8];
; O0-NEXT: 	mov.16b 	[[R16_H1]], [[VR4_16_V4H0]].x;
; O0-NEXT: 	mov.16b 	[[R16_H2]], [[VR4_16_V4H0]].y;
; O0-NEXT: 	mov.16b 	[[R16_H3]], [[VR4_16_V4H0]].z;
; O0-NEXT: 	mov.16b 	[[R16_H4]], [[VR4_16_V4H0]].w;
; O0-NEXT: 	mov.16b 	[[VR4_16_V4H1]].x, [[R16_H1]];
; O0-NEXT: 	mov.64b 	[[VR4_16_V4H2]].xyzw, [[VR4_16_V4H1]].xyzw;
; O0-NEXT: 	mov.16b 	[[VR4_16_V4H2]].y, [[R16_H2]];
; O0-NEXT: 	mov.64b 	[[VR4_16_V4H3]].xyzw, [[VR4_16_V4H2]].xyzw;
; O0-NEXT: 	mov.16b 	[[VR4_16_V4H3]].z, [[R16_H3]];
; O0-NEXT: 	mov.64b 	[[VR4_16_V4H4]].xyzw, [[VR4_16_V4H3]].xyzw;
; O0-NEXT: 	mov.16b 	[[VR4_16_V4H4]].w, [[R16_H4]];
; O0-NEXT: 	st.private.v4.16b	 [[[R32_W1]]], [[VR4_16_V4H4]];
; O0-NEXT: 	st.private.16b	 [[[R32_W1]] + 8], [[R16_H0]];
; O0-NEXT: 	return;
;
; CHECK-LABEL: @test_store_v5f16
; CHECK: st.private.v4.16b
; CHECK: st.private.16b
  store <5 x half> %val, ptr addrspace(4) %addr, align 16
  ret void
}

define void @test_store_v7f16(<7 x half> %val, ptr addrspace(4) %addr) {
; O0-LABEL: void @test_store_v7f16(
; O0-SAME: .reg .32b [[R32_W0:%[-a-zA-Z$._0-9]+]]
; O0-SAME: .reg .32b [[R32_W1:%[-a-zA-Z$._0-9]+]]
; O0: 	.reg .v4.16b [[VR4_16_V4H0:%[-a-zA-Z$._0-9]+]], [[VR4_16_V4H1:%[-a-zA-Z$._0-9]+]], [[VR4_16_V4H2:%[-a-zA-Z$._0-9]+]], [[VR4_16_V4H3:%[-a-zA-Z$._0-9]+]], [[VR4_16_V4H4:%[-a-zA-Z$._0-9]+]];
; O0-NEXT: 	.reg .v2.16b [[VR2_16_V2H0:%[-a-zA-Z$._0-9]+]], [[VR2_16_V2H1:%[-a-zA-Z$._0-9]+]], [[VR2_16_V2H2:%[-a-zA-Z$._0-9]+]];
; O0-NEXT: 	.reg .16b %h<0~7>;
; O0: 	ld.private.v4.16b	 [[VR4_16_V4H0]], [[[R32_W0]]];
; O0-NEXT: 	ld.private.v2.16b	 [[VR2_16_V2H0]], [[[R32_W0]] + 8];
; O0-NEXT: 	ld.private.16b	 %h0, [[[R32_W0]] + 12];
; O0-NEXT: 	mov.16b 	%h1, [[VR2_16_V2H0]].x;
; O0-NEXT: 	mov.16b 	%h2, [[VR2_16_V2H0]].y;
; O0-NEXT: 	mov.16b 	%h3, [[VR4_16_V4H0]].x;
; O0-NEXT: 	mov.16b 	%h4, [[VR4_16_V4H0]].y;
; O0-NEXT: 	mov.16b 	%h5, [[VR4_16_V4H0]].z;
; O0-NEXT: 	mov.16b 	%h6, [[VR4_16_V4H0]].w;
; O0-NEXT: 	mov.16b 	[[VR4_16_V4H1]].x, %h3;
; O0-NEXT: 	mov.64b 	[[VR4_16_V4H2]].xyzw, [[VR4_16_V4H1]].xyzw;
; O0-NEXT: 	mov.16b 	[[VR4_16_V4H2]].y, %h4;
; O0-NEXT: 	mov.64b 	[[VR4_16_V4H3]].xyzw, [[VR4_16_V4H2]].xyzw;
; O0-NEXT: 	mov.16b 	[[VR4_16_V4H3]].z, %h5;
; O0-NEXT: 	mov.64b 	[[VR4_16_V4H4]].xyzw, [[VR4_16_V4H3]].xyzw;
; O0-NEXT: 	mov.16b 	[[VR4_16_V4H4]].w, %h6;
; O0-NEXT: 	st.private.v4.16b	 [[[R32_W1]]], [[VR4_16_V4H4]];
; O0-NEXT: 	mov.16b 	[[VR2_16_V2H1]].x, %h1;
; O0-NEXT: 	mov.32b 	[[VR2_16_V2H2]].xy, [[VR2_16_V2H1]].xy;
; O0-NEXT: 	mov.16b 	[[VR2_16_V2H2]].y, %h2;
; O0-NEXT: 	st.private.v2.16b	 [[[R32_W1]] + 8], [[VR2_16_V2H2]];
; O0-NEXT: 	st.private.16b	 [[[R32_W1]] + 12], %h0;
; O0-NEXT: 	return;
;
; CHECK-LABEL: @test_store_v7f16
; CHECK: st.private.v4.16b
; CHECK: st.private.v2.16b
; CHECK: st.private.16b
  store <7 x half> %val, ptr addrspace(4) %addr, align 16
  ret void
}
