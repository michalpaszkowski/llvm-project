; RUN: not llc < %s -march=pisa -o /dev/null 2>&1 | FileCheck %s

; PISA requires natural alignment for atomic memory accesses.
; An under-aligned atomic is rejected with a hard error by AtomicExpandPass
; rather than silently mis-lowered, so the front-end never produces one.

; CHECK-DAG: error: unsupported atomicrmw add: instruction alignment 2 is smaller than the required 8-byte alignment
define i64 @unaligned_rmw(i64 %v, ptr addrspace(3) %p) {
  %r = atomicrmw add ptr addrspace(3) %p, i64 %v monotonic, align 2
  ret i64 %r
}

; CHECK-DAG: error: unsupported cmpxchg: instruction alignment 2 is smaller than the required 8-byte alignment
define i64 @unaligned_cmpxchg(i64 %c, i64 %n, ptr addrspace(3) %p) {
  %x = cmpxchg ptr addrspace(3) %p, i64 %c, i64 %n monotonic monotonic, align 2
  %v = extractvalue {i64, i1} %x, 0
  ret i64 %v
}

; CHECK-DAG: error: unsupported atomic load: instruction alignment 2 is smaller than the required 8-byte alignment
define i64 @unaligned_load(ptr addrspace(3) %p) {
  %r = load atomic i64, ptr addrspace(3) %p monotonic, align 2
  ret i64 %r
}

; CHECK-DAG: error: unsupported atomic store: instruction alignment 2 is smaller than the required 8-byte alignment
define void @unaligned_store(i64 %v, ptr addrspace(3) %p) {
  store atomic i64 %v, ptr addrspace(3) %p monotonic, align 2
  ret void
}
