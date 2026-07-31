; RUN: llc < %s -march=pisa -verify-machineinstrs -o - | FileCheck %s

; Regression test for an instruction-selection crash in
; PISARegisterInfo::getVectorRegClass. A bitcast from a 256-bit vector to a
; vector of 128-bit elements (<2 x i128>) followed by an extractelement used
; to be marked legal by the G_BITCAST / G_UNMERGE_VALUES legalizer rules.
; There is no PISA vector register class for 128-bit elements, so instruction
; selection asserted with `I != VecRegClassMap.end()`. The legalizer must
; instead decompose such casts into 64-bit-element operations.
;
; This pattern is produced by the middle-end when optimizing a post-decrement
; of sycl::marray<double, 4> (val--) with -O2 and ext_vector_type-based marray
; arithmetic.

; CHECK-LABEL: .function void @extract_hi_128_from_v4f64(
; CHECK:      ld.global.v4.64b {{.*}}, [[[P:%[-a-zA-Z$._0-9]+]]];
; CHECK:      mov.128b
; CHECK:      st.global.v4.32b
; CHECK:      return;
define void @extract_hi_128_from_v4f64(ptr addrspace(1) %p, ptr addrspace(1) %q) {
entry:
  %v = load <4 x double>, ptr addrspace(1) %p, align 8
  %bc = bitcast <4 x double> %v to <2 x i128>
  %e = extractelement <2 x i128> %bc, i64 0
  store i128 %e, ptr addrspace(1) %q, align 8
  ret void
}
