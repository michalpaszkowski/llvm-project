; RUN: llc < %s -march=pisa -stop-after=pisa-expand-intrinsics | FileCheck %s

declare void @llvm.memcpy.p1.p1.i64(ptr addrspace(1), ptr addrspace(1), i64, i1)
declare void @llvm.memmove.p1.p3.i64(ptr addrspace(1), ptr addrspace(3), i64, i1)
declare void @llvm.memset.p0.i64(ptr addrspace(4), i8, i64, i1)

; memcpy with constant length above the per-intrinsic limit is expanded to a loop.
; CHECK-LABEL: @memcpy_above_limit(
; CHECK: static-memcpy-expansion-main-body:
define void @memcpy_above_limit(ptr addrspace(1) %dst,
                                          ptr addrspace(1) %src) {
  call void @llvm.memcpy.p1.p1.i64(ptr addrspace(1) align 1 %dst,
                                    ptr addrspace(1) align 1 %src,
                                    i64 512, i1 false)
  ret void
}

; memmove exercises the memmove lowering path in the pass.
; Cross-addrspace memmove (global→shared) is processed but not loop-expanded.
; CHECK-LABEL: @memmove_above_limit(
define void @memmove_above_limit(ptr addrspace(1) %dst,
                                           ptr addrspace(3) %src) {
  call void @llvm.memmove.p1.p3.i64(ptr addrspace(1) align 1 %dst,
                                     ptr addrspace(3) align 1 %src,
                                     i64 512, i1 false)
  ret void
}

; memset with constant length above limit is expanded to a loop.
; CHECK-LABEL: @memset_above_limit(
; CHECK: static-memset-expansion-main-body:
define void @memset_above_limit(ptr addrspace(4) %dst) {
  call void @llvm.memset.p0.i64(ptr addrspace(4) align 1 %dst,
                                 i8 0, i64 512, i1 false)
  ret void
}

; Dynamic (non-constant) length is treated as unbounded and always expanded.
; CHECK-LABEL: @memcpy_dynamic_len_expanded(
; CHECK: dynamic-memcpy-expansion-main-body:
define void @memcpy_dynamic_len_expanded(ptr addrspace(1) %dst,
                                                    ptr addrspace(1) %src,
                                                    i64 %n) {
  call void @llvm.memcpy.p1.p1.i64(ptr addrspace(1) align 1 %dst,
                                    ptr addrspace(1) align 1 %src,
                                    i64 %n, i1 false)
  ret void
}
