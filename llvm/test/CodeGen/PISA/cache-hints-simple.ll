; RUN: llc -O0 < %s -march=pisa -verify-machineinstrs | FileCheck --check-prefixes=CHECK %s
; RUN: llc < %s -march=pisa -verify-machineinstrs | FileCheck --check-prefixes=CHECK %s

; CHECK: .function .64b @test1(.reg .32b 	[[PTR1:%w[0-9]+]])
; CHECK: .reg .64b [[DST1:%d[0-9]+]], [[DST2:%d[0-9]+]];
; CHECK: ld.private.64b                [[DST1]], [[[PTR1]]];
; CHECK: ld.global.L1uc.L2uc.L3uc.64b  [[DST2]], [[[DST1]]];
; CHECK: st.global.L1uc.L2uc.L3uc.64b [[[DST1]]], [[DST2]];
define ptr addrspace(1) @test1(ptr addrspace(4) noundef %0) {
  %3 = load ptr addrspace(1), ptr addrspace(4) %0, align 8
  %4 = load ptr addrspace(1), ptr addrspace(1) %3, align 8, !mmra !2
  store ptr addrspace(1) %4, ptr addrspace(1) %3, align 8, !mmra !2
  ret ptr addrspace(1) %4
}

!2 = !{!"pisa.cache.ctrl", !"2"}
