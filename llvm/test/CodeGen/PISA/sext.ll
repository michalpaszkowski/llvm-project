; RUN: llc -O0 < %s -march=pisa -verify-machineinstrs | FileCheck %s --check-prefixes=SEXT
; RUN: llc -O0 < %s -march=pisa > %t.pisa

; CHECK-LABEL: @test_sext_i32_i64
define i64 @test_sext_i32_i64(i32 %a) {
  ; SEXT:       .reg .64b [[RES:%d[0-9]+]]
  ; SEXT:       sext.64b.32b [[RES:%d[0-9]+]], %w{{[0-9]+}}
  ; SEXT-NEXT:  return [[RES]]
  %x = sext i32 %a to i64
  ret i64 %x
}

; CHECK-LABEL: @test_sext_i16_i64
define i64 @test_sext_i16_i64(i16 %a) {
  ; SEXT:       .reg .64b [[RES:%d[0-9]+]]
  ; SEXT:       sext.64b.16b [[RES:%d[0-9]+]], %h{{[0-9]+}}
  ; SEXT-NEXT:  return [[RES]]
  %x = sext i16 %a to i64
  ret i64 %x
}

; CHECK-LABEL: @test_sext_i8_i64
define i64 @test_sext_i8_i64(i8 %a) {
  ; SEXT:       .reg .64b [[RES:%d[0-9]+]]
  ; SEXT:       sext.64b.8b [[RES:%d[0-9]+]], %b{{[0-9]+}}
  ; SEXT-NEXT:  return [[RES]]
  %x = sext i8 %a to i64
  ret i64 %x
}

; CHECK-LABEL: @test_sext_i16_i32
define i32 @test_sext_i16_i32(i16 %a) {
  ; SEXT:       .reg .32b [[RES:%w[0-9]+]]
  ; SEXT:       sext.32b.16b [[RES:%w[0-9]+]], %h{{[0-9]+}}
  ; SEXT-NEXT:  return [[RES]]
  %x = sext i16 %a to i32
  ret i32 %x
}

; CHECK-LABEL: @test_sext_i8_i32
define i32 @test_sext_i8_i32(i8 %a) {
  ; SEXT:       .reg .32b [[RES:%w[0-9]+]]
  ; SEXT:       sext.32b.8b [[RES:%w[0-9]+]], %b{{[0-9]+}}
  ; SEXT-NEXT:  return [[RES]]
  %x = sext i8 %a to i32
  ret i32 %x
}

; CHECK-LABEL: @test_sext_i8_i16
define i16 @test_sext_i8_i16(i8 %a) {
  ; SEXT:       .reg .16b [[RES:%h[0-9]+]]
  ; SEXT:       sext.16b.8b [[RES:%h[0-9]+]], %b{{[0-9]+}}
  ; SEXT-NEXT:  return [[RES]]
  %x = sext i8 %a to i16
  ret i16 %x
}

; CHECK-LABEL: @test_sext_i1_i8
define i8 @test_sext_i1_i8(i16 %a) {
  ; SEXT:       ucmp.eq.16b [[PRED:%p[0-9]+]]
  ; SEXT:       sel.16b   %h{{[0-9]+}}, -1, 0, [[PRED]]
  ; SEXT:       trunc.8b.16b
  %p = icmp eq i16 %a, 0
  %x = sext i1 %p to i8
  ret i8 %x
}

; CHECK-LABEL: @test_sext_i1_i16
define i16 @test_sext_i1_i16(i16 %a) {
  ; SEXT:       ucmp.eq.16b [[PRED:%p[0-9]+]]
  ; SEXT:       sel.16b   %h{{[0-9]+}}, -1, 0, [[PRED]]
  %p = icmp eq i16 %a, 0
  %x = sext i1 %p to i16
  ret i16 %x
}

; CHECK-LABEL: @test_sext_i1_i32
define i32 @test_sext_i1_i32(i16 %a) {
  ; SEXT:       ucmp.eq.16b
  ; SEXT-NOT:   sel.32b
  %p = icmp eq i16 %a, 0
  %x = sext i1 %p to i32
  ret i32 %x
}

; CHECK-LABEL: @test_sext_i1_i64
define i64 @test_sext_i1_i64(i16 %a) {
  ; SEXT:       ucmp.eq.16b [[PRED:%p[0-9]+]]
  ; SEXT:       sel.64b   %d{{[0-9]+}}, -1, 0, [[PRED]]
  %p = icmp eq i16 %a, 0
  %x = sext i1 %p to i64
  ret i64 %x
}
