; RUN: not llc -march=pisa -stop-after=pisa-verifier -o /dev/null %s 2>&1 | FileCheck %s

; CHECK: PISA Verifier: AtomicRMW on constant memory is not allowed

define pisa_kernel void @atomic(ptr addrspace(2) %ptr, half %val) {
  %A = atomicrmw fmin ptr addrspace(2) %ptr, half %val syncscope("gpu") monotonic, align 2
  ret void
}