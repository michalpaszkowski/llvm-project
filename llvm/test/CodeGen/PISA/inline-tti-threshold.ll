; RUN: opt -mtriple=pisa -passes='module-inline' %s -S | FileCheck %s

; This test exercises the PISA TTI inline-cost hooks.
;
; @kernel / @callee_with_many_uses cover PISATTIImpl::adjustInliningThreshold
; and the BFS helper PISATTIImpl::estimateNumMemAccesses: the callee uses its
; addrspace(4) (GENERIC) pointer parameter through a long chain of
; instructions so that the BFS exhausts its NumAttemptsLeft budget
; (32 iterations) and falls into the `if (NumAttemptsLeft < 0)` branch that
; bumps the access estimate.
;
; @kernel_alloca / @callee_uses_alloca cover PISATTIImpl::getCallerAllocaCost:
; a private (addrspace(4)) alloca is passed to a callee that loads and stores
; through it, so the InlineCost SROA machinery calls onInitializeSROAArg ->
; getCallerAllocaCost to estimate the SROA savings (alloca size * per-byte
; bonus).
;
; In both cases the bonus makes the tiny callee profitable and it is inlined.
;
; CHECK-LABEL: define pisa_kernel void @kernel(
; CHECK-NOT: call {{.*}}@callee_with_many_uses
; CHECK-LABEL: define pisa_kernel void @kernel_alloca(
; CHECK-NOT: call {{.*}}@callee_uses_alloca

target triple = "pisa"

define internal void @callee_with_many_uses(ptr addrspace(0) %p, i32 %n) {
entry:
  ; 36 loads through chained GEPs — well beyond the 32-attempt budget
  ; of estimateNumMemAccesses, so NumAttemptsLeft drops below zero.
  %g0  = getelementptr i32, ptr addrspace(0) %p, i32 0
  %l0  = load i32, ptr addrspace(0) %g0
  %g1  = getelementptr i32, ptr addrspace(0) %p, i32 1
  %l1  = load i32, ptr addrspace(0) %g1
  %g2  = getelementptr i32, ptr addrspace(0) %p, i32 2
  %l2  = load i32, ptr addrspace(0) %g2
  %g3  = getelementptr i32, ptr addrspace(0) %p, i32 3
  %l3  = load i32, ptr addrspace(0) %g3
  %g4  = getelementptr i32, ptr addrspace(0) %p, i32 4
  %l4  = load i32, ptr addrspace(0) %g4
  %g5  = getelementptr i32, ptr addrspace(0) %p, i32 5
  %l5  = load i32, ptr addrspace(0) %g5
  %g6  = getelementptr i32, ptr addrspace(0) %p, i32 6
  %l6  = load i32, ptr addrspace(0) %g6
  %g7  = getelementptr i32, ptr addrspace(0) %p, i32 7
  %l7  = load i32, ptr addrspace(0) %g7
  %g8  = getelementptr i32, ptr addrspace(0) %p, i32 8
  %l8  = load i32, ptr addrspace(0) %g8
  %g9  = getelementptr i32, ptr addrspace(0) %p, i32 9
  %l9  = load i32, ptr addrspace(0) %g9
  %g10 = getelementptr i32, ptr addrspace(0) %p, i32 10
  %l10 = load i32, ptr addrspace(0) %g10
  %g11 = getelementptr i32, ptr addrspace(0) %p, i32 11
  %l11 = load i32, ptr addrspace(0) %g11
  %g12 = getelementptr i32, ptr addrspace(0) %p, i32 12
  %l12 = load i32, ptr addrspace(0) %g12
  %g13 = getelementptr i32, ptr addrspace(0) %p, i32 13
  %l13 = load i32, ptr addrspace(0) %g13
  %g14 = getelementptr i32, ptr addrspace(0) %p, i32 14
  %l14 = load i32, ptr addrspace(0) %g14
  %g15 = getelementptr i32, ptr addrspace(0) %p, i32 15
  %l15 = load i32, ptr addrspace(0) %g15
  %g16 = getelementptr i32, ptr addrspace(0) %p, i32 16
  %l16 = load i32, ptr addrspace(0) %g16
  %g17 = getelementptr i32, ptr addrspace(0) %p, i32 17
  %l17 = load i32, ptr addrspace(0) %g17
  %g18 = getelementptr i32, ptr addrspace(0) %p, i32 18
  %l18 = load i32, ptr addrspace(0) %g18
  %g19 = getelementptr i32, ptr addrspace(0) %p, i32 19
  %l19 = load i32, ptr addrspace(0) %g19
  %g20 = getelementptr i32, ptr addrspace(0) %p, i32 20
  %l20 = load i32, ptr addrspace(0) %g20
  %g21 = getelementptr i32, ptr addrspace(0) %p, i32 21
  %l21 = load i32, ptr addrspace(0) %g21
  %g22 = getelementptr i32, ptr addrspace(0) %p, i32 22
  %l22 = load i32, ptr addrspace(0) %g22
  %g23 = getelementptr i32, ptr addrspace(0) %p, i32 23
  %l23 = load i32, ptr addrspace(0) %g23
  %g24 = getelementptr i32, ptr addrspace(0) %p, i32 24
  %l24 = load i32, ptr addrspace(0) %g24
  %g25 = getelementptr i32, ptr addrspace(0) %p, i32 25
  %l25 = load i32, ptr addrspace(0) %g25
  %g26 = getelementptr i32, ptr addrspace(0) %p, i32 26
  %l26 = load i32, ptr addrspace(0) %g26
  %g27 = getelementptr i32, ptr addrspace(0) %p, i32 27
  %l27 = load i32, ptr addrspace(0) %g27
  %g28 = getelementptr i32, ptr addrspace(0) %p, i32 28
  %l28 = load i32, ptr addrspace(0) %g28
  %g29 = getelementptr i32, ptr addrspace(0) %p, i32 29
  %l29 = load i32, ptr addrspace(0) %g29
  %g30 = getelementptr i32, ptr addrspace(0) %p, i32 30
  %l30 = load i32, ptr addrspace(0) %g30
  %g31 = getelementptr i32, ptr addrspace(0) %p, i32 31
  %l31 = load i32, ptr addrspace(0) %g31
  %g32 = getelementptr i32, ptr addrspace(0) %p, i32 32
  %l32 = load i32, ptr addrspace(0) %g32
  %g33 = getelementptr i32, ptr addrspace(0) %p, i32 33
  %l33 = load i32, ptr addrspace(0) %g33
  %g34 = getelementptr i32, ptr addrspace(0) %p, i32 34
  %l34 = load i32, ptr addrspace(0) %g34
  %g35 = getelementptr i32, ptr addrspace(0) %p, i32 35
  %l35 = load i32, ptr addrspace(0) %g35
  store i32 %l0, ptr addrspace(0) %g0
  store i32 %l1, ptr addrspace(0) %g1
  store i32 %l2, ptr addrspace(0) %g2
  store i32 %l3, ptr addrspace(0) %g3
  store i32 %l4, ptr addrspace(0) %g4
  store i32 %l5, ptr addrspace(0) %g5
  store i32 %l6, ptr addrspace(0) %g6
  store i32 %l7, ptr addrspace(0) %g7
  store i32 %l8, ptr addrspace(0) %g8
  ret void
}

define pisa_kernel void @kernel(ptr addrspace(0) %dst, i32 %n) {
  call void @callee_with_many_uses(ptr addrspace(0) %dst, i32 %n)
  ret void
}

define internal void @callee_uses_alloca(ptr addrspace(4) %p) {
entry:
  %v = load i32, ptr addrspace(4) %p, align 4
  %inc = add i32 %v, 1
  store i32 %inc, ptr addrspace(4) %p, align 4
  ret void
}

define pisa_kernel void @kernel_alloca() {
  %a = alloca i32, align 4, addrspace(4)
  call void @callee_uses_alloca(ptr addrspace(4) %a)
  ret void
}
