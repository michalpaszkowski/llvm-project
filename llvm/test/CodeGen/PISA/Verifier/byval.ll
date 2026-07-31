; RUN: not llc -march=pisa -stop-after=pisa-verifier -o /dev/null %s 2>&1 | FileCheck %s

; CHECK: PISA Verifier: Kernel pointer arguments with byval attribute are expected to be in the private addrspace
; CHECK-NEXT: Kernel: test_byval
; CHECK-NEXT: Arg no: 1

%struct = type { i32, i32 }

define pisa_kernel void @test_byval(ptr addrspace(4) byval(%struct) %arg0, ptr addrspace(1) byval(%struct) %arg1) {
  ret void
}
