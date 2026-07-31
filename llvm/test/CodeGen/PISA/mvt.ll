; RUN: llc < %s -march=pisa -verify-machineinstrs -o %t.pisa
; RUN: FileCheck %s < %t.pisa
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs

define internal i64 @_switch64(i64 %0) {
entry:
  switch i64 %0, label %default [
    i64 0, label %index
  ]
index:                                       ; preds = %entry
  ret i64 0

default:                                     ; preds = %entry, %index
  ret i64 1
}
; CHECK: .function .64b @_switch64
; CHECK:  ucmp.{{ne|eq}}.64b     %p0, %d0, 0;

define internal i32 @_switch32(i32 %0) {
entry:
  switch i32 %0, label %default [
    i32 0, label %index
  ]
index:                                       ; preds = %entry
  ret i32 0

default:                                     ; preds = %entry, %index
  ret i32 1
}
; CHECK: .function .32b @_switch32
; CHECK:  ucmp.{{ne|eq}}.32b     %p0, %w0, 0;

