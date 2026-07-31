; RUN: not llc -march=pisa -stop-after=pisa-verifier -o /dev/null %s 2>&1 | FileCheck %s

; CHECK: PISA Verifier: Store to constant memory is not allowed

define pisa_kernel void @vadd(ptr addrspace(2) %ptr) {
  store ptr null, ptr addrspace(2) %ptr, align 8
  ret void
}
