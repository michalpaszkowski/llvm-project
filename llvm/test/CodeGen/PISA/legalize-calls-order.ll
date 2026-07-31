; RUN: llc < %s -march=pisa -print-after=pisa-legalize-calls 2>&1 | FileCheck %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs

; check that modified function arguments are emitted in the natural order

; CHECK-LABEL: define void @test_arg_order
; CHECK-SAME: (ptr addrspace(4) [[PTR_A:%.*]], ptr addrspace(4) [[PTR_B:%.*]], ptr addrspace(4) [[PTR_C:%.*]], ptr addrspace(4) [[OUT:%.*]])
; CHECK-NEXT: [[A:%.*]] = load <5 x i8>, ptr addrspace(4) [[PTR_A]], align 8
; CHECK-NEXT: [[B:%.*]] = load <5 x i8>, ptr addrspace(4) [[PTR_B]], align 8
; CHECK-NEXT: [[C:%.*]] = load <5 x i8>, ptr addrspace(4) [[PTR_C]], align 8
; CHECK-NEXT: [[TMP:%.*]] = add <5 x i8> [[A]], [[B]]
; CHECK-NEXT: [[SUM:%.*]] = add <5 x i8> [[TMP]], [[C]]
; CHECK-NEXT: store <5 x i8> [[SUM]], ptr addrspace(4) [[OUT]], align 8
; CHECK-NEXT: ret void
define <5 x i8> @test_arg_order(<5 x i8> %a, <5 x i8> %b, <5 x i8> %c) {
  %tmp = add <5 x i8> %a, %b
  %sum = add <5 x i8> %tmp, %c
  ret <5 x i8> %sum
}
