; RUN: llc < %s -march=pisa --verify-machineinstrs -stop-after=irtranslator - | FileCheck %s -check-prefix=TRANS
; RUN: llc < %s -march=pisa --verify-machineinstrs - | FileCheck %s -check-prefix=ASM
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs | FileCheck --check-prefix=O0 %s


declare hidden ptr addrspace(1) @ext(ptr addrspace(1))

define ptr addrspace(1) @tail_call_assert_align() {
entry:
; TRANS: [[CR:%[0-9]+]]:reg64b(p1) = functionCall_i64_r @ext
; TRANS: [[AL:%[0-9]+]]:_(p1) = G_ASSERT_ALIGN [[CR]], 4
; TRANS: [[RV:%[0-9]+]]:reg64b(p1) = COPY [[AL]]
; TRANS: retValue_i64_r [[RV]]

; ASM: call [[CR:%d[0-9]+]], @ext
; O0: call [[CR:%d[0-9]+]], @ext
; ASM: return [[CR]]
; O0: return [[CR]]

  %call = tail call align 4 ptr addrspace(1) @ext(ptr addrspace(1) null)
  ret ptr addrspace(1) %call
}

