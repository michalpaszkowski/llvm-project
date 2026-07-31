; REQUIRES: system-linux
; RUN: opt -mtriple=pisa -S -O2 %s -print-pipeline-passes -o /dev/null > %t.passes 2>&1
; RUN: sh -c 'opt -mtriple=pisa -S -passes="`cat %t.passes`" %s 2>&1' | FileCheck %s

define i32 @example() {
  ret i32 75
}

; CHECK-LABEL: @example()
; CHECK: ret i32 75
