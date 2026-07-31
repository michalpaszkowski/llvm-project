; This test validates function signature printing
; RUN: llc < %s -march=pisa -verify-machineinstrs -o %t.pisa
; RUN: FileCheck %s < %t.pisa --check-prefixes=FUNCARGS
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs

; CHECK-LABEL: @test_reg8
; FUNCARGS:  .function .8b @test_reg8(.reg .8b [[ARG0:%[-a-zA-Z$._0-9]+]], .reg .8b [[ARG1:%[-a-zA-Z$._0-9]+]])
; FUNCARGS:  zext.16b.8b [[EARG0:%[-a-zA-Z$._0-9]+]], [[ARG0]]
; FUNCARGS:  zext.16b.8b [[EARG1:%[-a-zA-Z$._0-9]+]], [[ARG1]]
; FUNCARGS:  iadd.16b  %{{[-a-zA-Z$._0-9]+}}, [[EARG0]], [[EARG1]];
define i8 @test_reg8(i8 %a, i8 %b) {
  %result = add i8 %a, %b
  ret i8 %result
}

; CHECK-LABEL: @test_reg16
; FUNCARGS:  .function .16b @test_reg16(.reg .16b [[ARG0:%[-a-zA-Z$._0-9]+]], .reg .16b [[ARG1:%[-a-zA-Z$._0-9]+]])
; FUNCARGS:  iadd.16b  %{{[-a-zA-Z$._0-9]+}}, [[ARG0]], [[ARG1]];
define i16 @test_reg16(i16 %a, i16 %b) {
  %result = add i16 %a, %b
  ret i16 %result
}

; CHECK-LABEL: @test_reg32
; FUNCARGS:  .function .32b @test_reg32(.reg .32b [[ARG0:%[-a-zA-Z$._0-9]+]], .reg .32b [[ARG1:%[-a-zA-Z$._0-9]+]])
; FUNCARGS:  iadd.32b  %{{[-a-zA-Z$._0-9]+}}, [[ARG0]], [[ARG1]];
define i32 @test_reg32(i32 %a, i32 %b) {
  %result = add i32 %a, %b
  ret i32 %result
}

; CHECK-LABEL: @test_reg64
; FUNCARGS:  .function .64b @test_reg64(.reg .64b [[ARG0:%[-a-zA-Z$._0-9]+]], .reg .64b [[ARG1:%[-a-zA-Z$._0-9]+]])
; FUNCARGS:  iadd.64b %{{[-a-zA-Z$._0-9]+}}, [[ARG0]], [[ARG1]];
define i64 @test_reg64(i64 %a, i64 %b) {
  %result = add i64 %a, %b
  ret i64 %result
}

; CHECK-LABEL: @test_empty
; FUNCARGS:  .function void @test_empty()
define void @test_empty() {
  ret void
}
