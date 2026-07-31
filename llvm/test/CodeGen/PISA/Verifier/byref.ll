; RUN: not llc -march=pisa -stop-after=pisa-verifier -o /dev/null %s 2>&1 | FileCheck %s

; CHECK: PISA Verifier: Kernel pointer arguments with the byref attribute are not allowed
; CHECK-NEXT: Kernel: test_byref
; CHECK-NEXT: Arg no: 0

%struct = type { i32, i32 }

define pisa_kernel void @test_byref(ptr byref(%struct) %arg) {
  ret void
}
