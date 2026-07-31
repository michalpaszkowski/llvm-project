; RUN: llc < %s -march=pisa %disable_optional_optimizations -verify-machineinstrs | FileCheck --check-prefixes=CHECK-LESS-OPT %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs | FileCheck --check-prefix=O0 %s

define pisa_kernel void @scaleAndOffsetHalf8Vector(ptr addrspace(1) writeonly align 16 captures(none) %a, ptr addrspace(1) readonly align 16 captures(none) %b, half %c, half %d) {
; O0-LABEL: @scaleAndOffsetHalf8Vector(
; O0: 	.reg .64b %d<0~8>;
; O0-NEXT: 	.reg .16b %h<0~18>;
; O0-NEXT: 	.reg .32b %w<0~11>;
; O0-NEXT: 	.reg .v4.32b [[VR4_32_V4W0:%[-a-zA-Z$._0-9]+]], [[VR4_32_V4W1:%[-a-zA-Z$._0-9]+]], [[VR4_32_V4W2:%[-a-zA-Z$._0-9]+]], [[VR4_32_V4W3:%[-a-zA-Z$._0-9]+]], [[VR4_32_V4W4:%[-a-zA-Z$._0-9]+]];
; O0-NEXT: 	.reg .v2.16b %v2h<0~12>;
; O0: 	return;
;
; CHECK-LESS-OPT-LABEL: @scaleAndOffsetHalf8Vector(
; CHECK-LESS-OPT-SAME: .param[8] .addrspace(global) .ptr_align(16){{( .access\(writeonly\))?}} [[PARAM_ARG0:%[-a-zA-Z$._0-9]+]]
; CHECK-LESS-OPT-SAME: .param[8] .addrspace(global) .ptr_align(16){{( .access\(readonly\))?}} [[PARAM_ARG1:%[-a-zA-Z$._0-9]+]]
; CHECK-LESS-OPT-SAME: .param[2] .align(4) [[PARAM_ARG2:%[-a-zA-Z$._0-9]+]]
; CHECK-LESS-OPT-SAME: .param[2] .align(4) [[PARAM_ARG3:%[-a-zA-Z$._0-9]+]]
; CHECK-LESS-OPT: 	.reg .64b %d<0~6>;
; CHECK-LESS-OPT-NEXT: 	.reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]], [[R16_H1:%[-a-zA-Z$._0-9]+]];
; CHECK-LESS-OPT-NEXT: 	.reg .v4.32b [[VR4_32_V4W0:%[-a-zA-Z$._0-9]+]], [[VR4_32_V4W1:%[-a-zA-Z$._0-9]+]];
; CHECK-LESS-OPT-NEXT: 	.reg .v2.16b %v2h<0~8>;
; CHECK-LESS-OPT: 	ld.param.64b %d0, [[[PARAM_ARG0]]];
; CHECK-LESS-OPT-NEXT: 	ld.param.64b %d1, [[[PARAM_ARG1]]];
; CHECK-LESS-OPT-NEXT: 	ld.param.16b [[R16_H0]], [[[PARAM_ARG2]]];
; CHECK-LESS-OPT-NEXT: 	ld.param.16b [[R16_H1]], [[[PARAM_ARG3]]];
; CHECK-LESS-OPT-NEXT: 	zext.64b.32b 	%d2, %localid.x;
; CHECK-LESS-OPT-NEXT: 	umad.full.32b 	%d3, %localsize.x, %groupid.x, %d2;
; CHECK-LESS-OPT-NEXT: 	iadd.64b 	%d4, %d3, %globaloffset.x;
; CHECK-LESS-OPT-NEXT: 	shl.64b 	%d5, %d4, 4;
; CHECK-LESS-OPT-NEXT: 	ld.global.v4.32b	 [[VR4_32_V4W0]], [%d1 + %d5];
; CHECK-LESS-OPT-NEXT: 	mov.32b 	%v2h0.xy, [[VR4_32_V4W0]].x;
; CHECK-LESS-OPT-NEXT: 	mov.32b 	%v2h1.xy, [[VR4_32_V4W0]].y;
; CHECK-LESS-OPT-NEXT: 	mov.32b 	%v2h2.xy, [[VR4_32_V4W0]].z;
; CHECK-LESS-OPT-NEXT: 	mov.32b 	%v2h3.xy, [[VR4_32_V4W0]].w;
; CHECK-LESS-OPT-NEXT: 	fmad.hf 	%v2h4.x, %v2h0.x, [[R16_H0]], [[R16_H1]];
; CHECK-LESS-OPT-NEXT: 	fmad.hf 	%v2h4.y, %v2h0.y, [[R16_H0]], [[R16_H1]];
; CHECK-LESS-OPT-NEXT: 	fmad.hf 	%v2h5.x, %v2h1.x, [[R16_H0]], [[R16_H1]];
; CHECK-LESS-OPT-NEXT: 	fmad.hf 	%v2h5.y, %v2h1.y, [[R16_H0]], [[R16_H1]];
; CHECK-LESS-OPT-NEXT: 	fmad.hf 	%v2h6.x, %v2h2.x, [[R16_H0]], [[R16_H1]];
; CHECK-LESS-OPT-NEXT: 	fmad.hf 	%v2h6.y, %v2h2.y, [[R16_H0]], [[R16_H1]];
; CHECK-LESS-OPT-NEXT: 	fmad.hf 	%v2h7.x, %v2h3.x, [[R16_H0]], [[R16_H1]];
; CHECK-LESS-OPT-NEXT: 	fmad.hf 	%v2h7.y, %v2h3.y, [[R16_H0]], [[R16_H1]];
; CHECK-LESS-OPT-NEXT: 	mov.32b 	[[VR4_32_V4W1]].x, %v2h4.xy;
; CHECK-LESS-OPT-NEXT: 	mov.32b 	[[VR4_32_V4W1]].y, %v2h5.xy;
; CHECK-LESS-OPT-NEXT: 	mov.32b 	[[VR4_32_V4W1]].z, %v2h6.xy;
; CHECK-LESS-OPT-NEXT: 	mov.32b 	[[VR4_32_V4W1]].w, %v2h7.xy;
; CHECK-LESS-OPT-NEXT: 	st.global.v4.32b	 [%d0 + %d5], [[VR4_32_V4W1]];
; CHECK-LESS-OPT-NEXT: 	return;
entry:
  %0 = tail call i32 @llvm.pisa.group.id.x()
  %1 = zext i32 %0 to i64
  %2 = tail call i32 @llvm.pisa.local.size.x()
  %3 = zext i32 %2 to i64
  %4 = mul nuw i64 %3, %1
  %5 = tail call i32 @llvm.pisa.local.id.x()
  %6 = zext nneg i32 %5 to i64
  %7 = add nuw i64 %4, %6
  %10 = call i64 @llvm.pisa.global.offset.x()
  %11 = add i64 %7, %10
  %arrayidx = getelementptr inbounds nuw <8 x half>, ptr addrspace(1) %b, i64 %11
  %12 = load <8 x half>, ptr addrspace(1) %arrayidx, align 16
  %splat.splatinsert = insertelement <8 x half> poison, half %c, i64 0
  %splat.splat = shufflevector <8 x half> %splat.splatinsert, <8 x half> poison, <8 x i32> zeroinitializer
  %splat.splatinsert1 = insertelement <8 x half> poison, half %d, i64 0
  %splat.splat2 = shufflevector <8 x half> %splat.splatinsert1, <8 x half> poison, <8 x i32> zeroinitializer
  %13 = tail call <8 x half> @llvm.fma.v8f16(<8 x half> %12, <8 x half> %splat.splat, <8 x half> %splat.splat2)
  %arrayidx4 = getelementptr inbounds nuw <8 x half>, ptr addrspace(1) %a, i64 %11
  store <8 x half> %13, ptr addrspace(1) %arrayidx4, align 16
  ret void
}
