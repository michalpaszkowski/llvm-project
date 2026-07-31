; RUN: llc < %s -verify-machineinstrs -march=pisa | FileCheck %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs

; Similar test is included in private-dcl.ll, this variant checks the exact
; names of the stack objects which may be changed by PISA reader. Therefore
; this file doesn't check PISA parsing case.

declare void @stack.user(ptr addrspace(4) %stack)

; CHECK-LABEL: .function void @alloca_dead
define void @alloca_dead(i8 %x, i32 %idx1, i32 %idx2) {
; Here we ensure that if stack coloring has removed one of the allocations we
; emit allocations with correct indices
; CHECK:     .private .align 4 @R0[4]
; CHECK:     .private .align 4 @R1[4]
; CHECK-NOT: .private .align 4 @R2[4]
; CHECK:     .private .align 4 @R3[4]
  %dead0 = alloca i32, align 4, addrspace(4)
  %live0 = alloca i32, align 4, addrspace(4)
  %dead1 = alloca i32, align 4, addrspace(4)
  %live1 = alloca i32, align 4, addrspace(4)

  call void @llvm.lifetime.start.p0(ptr addrspace(4) nonnull %dead0)
  call void @llvm.lifetime.start.p0(ptr addrspace(4) nonnull %live0)
  call void @llvm.lifetime.start.p0(ptr addrspace(4) nonnull %live1)

  call void @stack.user(ptr addrspace(4) %dead0)

  call void @llvm.lifetime.end.p0(ptr addrspace(4) nonnull %dead0)
  call void @llvm.lifetime.start.p0(ptr addrspace(4) nonnull %dead1)

  call void @stack.user(ptr addrspace(4) %live0)
  call void @stack.user(ptr addrspace(4) %live1)
  call void @stack.user(ptr addrspace(4) %dead1)

  call void @llvm.lifetime.end.p0(ptr addrspace(4) nonnull %live0)
  call void @llvm.lifetime.end.p0(ptr addrspace(4) nonnull %live1)
  call void @llvm.lifetime.end.p0(ptr addrspace(4) nonnull %dead1)

  ret void
}
